import type { Config } from "@netlify/functions";
import { getStore } from "@netlify/blobs";
import { XMLParser } from "fast-xml-parser";

const createErrorResponse = (message: string, status: number) => {
  console.error(message);
  return Response.json({
    error: message,
  }, {
    status,
  });
};

export default async (req: Request) => {
  try {
    const { next_run } = await req.json();
    console.log(`IndexNow update. Next run: ${next_run}`);

    const site = process.env.URL;
    if (!site) {
      return createErrorResponse(
        "IndexNow update failed: site URL is not configured in environment variables.",
        500,
      );
    }

    const indexNowKey = process.env.INDEXNOW_KEY;
    if (!indexNowKey) {
      return createErrorResponse(
        "IndexNow update failed: INDEXNOW_KEY environment variable is required.",
        500,
      );
    }

    const siteUrl = new URL(site);
    const sitemapUrl = new URL("/sitemap.xml", siteUrl).href;
    const sitemapResponse = await fetch(sitemapUrl);

    if (!sitemapResponse.ok) {
      return createErrorResponse(
        `Failed to fetch sitemap: ${sitemapResponse.status}`,
        502,
      );
    }

    const xml = await sitemapResponse.text();
    const parser = new XMLParser({
      ignoreAttributes: false,
      trimValues: true,
      parseTagValue: true,
      parseAttributeValue: false,
    });

    const parsed = parser.parse(xml);
    const urlset = parsed?.urlset;

    if (!urlset) {
      return createErrorResponse(
        "IndexNow update failed: sitemap.xml did not contain a valid <urlset>.",
        500,
      );
    }

    const urlEntries: string[] = Array.from(urlset.url ?? [], (entry: { loc: string }) => entry.loc);

    // Retrieve the previous URLs from the blob store
    const store = getStore("indexnow");
    const blobKey = "urls";
    const previousEntries = await store.get(blobKey, { type: "text" });
    // NOTE: Update the blob store with the current URLs only if the IndexNow submission is successful, to avoid losing track of previous URLs in case of a failure.

    const currentUrls = new Set(urlEntries);
    const previousUrls = new Set(previousEntries ? JSON.parse(previousEntries) as string[] : []);
    const changedUrls = currentUrls.symmetricDifference(previousUrls);

    const urlsToSubmit: string[] = changedUrls.size > 0 ? Array.from(changedUrls) : [];

    if (urlsToSubmit.length === 0) {
      console.log("IndexNow update: no URLs changed since the last run.");
      return Response.json({
        message: "No changed URLs to submit.",
      }, {
        status: 200,
      });
    }

    const indexNowEndpoint = "https://api.indexnow.org/indexnow";
    const indexNowResponse = await fetch(indexNowEndpoint, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "charset": "utf-8"
      },
      body: JSON.stringify({
        "host": siteUrl,
        "key": indexNowKey,
        "urlList": urlsToSubmit,
      }),
    });

    if (!indexNowResponse.ok) {
      const errorText = await indexNowResponse.text();
      return createErrorResponse(
        `IndexNow request failed: ${indexNowResponse.status} ${indexNowResponse.statusText} - ${errorText}`,
        502,
      );
    }

    // Store the current URLs for future comparison
    await store.set(blobKey, JSON.stringify(urlEntries));

    console.log(`IndexNow update submitted successfully. Count: ${urlsToSubmit.length}`);
    return Response.json({
      message: "IndexNow update submitted successfully.",
      count: urlsToSubmit.length,
      urls: urlsToSubmit,
    }, {
      status: 200,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown error";
    return createErrorResponse(`IndexNow update failed: ${message}`, 500);
  }
};

export const config: Config = {
  schedule: "@daily",
};
