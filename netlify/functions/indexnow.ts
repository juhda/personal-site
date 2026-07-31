import type { Config } from "@netlify/functions";
import { getStore } from "@netlify/blobs";
import { XMLParser } from "fast-xml-parser";

export default async (req: Request) => {
  const { next_run } = await req.json();

  const site = process.env.URL;
  if (!site) {
    throw new Error("IndexNow update failed: site URL is not configured in environment variables.");
  }

  const indexNowKey = process.env.INDEXNOW_KEY;
  if (!indexNowKey) {
    throw new Error("IndexNow update failed: INDEXNOW_KEY environment variable is required.");
  }

  console.log(`IndexNow update. Next run: ${next_run}`);

  const siteUrl = new URL(site);
  const sitemapUrl = new URL("/sitemap.xml", siteUrl).href;
  const sitemapResponse = await fetch(sitemapUrl);

  if (!sitemapResponse.ok) {
    throw new Error(`Failed to fetch sitemap: ${sitemapResponse.status}`);
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
    throw new Error("IndexNow update failed: sitemap.xml did not contain a valid <urlset>.");
  }

  const urlEntries: string[] = Array.from(urlset.url ?? [], (entry: { loc: string }) => entry.loc);

  const store = getStore("indexnow");
  const blobKey = "urls";
  const previousEntries = await store.get(blobKey, { type: "text" });
  await store.set(blobKey, JSON.stringify(urlEntries));

  const currentUrls = new Set(urlEntries);
  const previousUrls = new Set(previousEntries ? JSON.parse(previousEntries) as string[] : []);
  const addedUrls = currentUrls.difference(previousUrls);
  const removedUrls = previousUrls.difference(currentUrls);

  const urlsToAdd = addedUrls.size > 0 ? Array.from(addedUrls) : [];
  const urlsToRemove = removedUrls.size > 0 ? Array.from(removedUrls) : [];

  // if (urlsToAdd.length === 0) {
  //   console.log("IndexNow update: no new URLs changed since the last run.");
  //   return new Response(JSON.stringify({ message: "No changed URLs to submit." }), {
  //     status: 200,
  //     headers: { "Content-Type": "application/json" },
  //   });
  // }

  // const host = siteUrl.host;
  // const indexNowEndpoint = `https://api.indexnow.org/indexnow?host=${encodeURIComponent(host)}&key=${encodeURIComponent(indexNowKey)}`;
  // const indexNowResponse = await fetch(indexNowEndpoint, {
  //   method: "POST",
  //   headers: {
  //     "Content-Type": "application/json",
  //   },
  //   body: JSON.stringify({
  //     host,
  //     key: indexNowKey,
  //     urlList: urlsToAdd,
  //   }),
  // });

  // if (!indexNowResponse.ok) {
  //   const errorText = await indexNowResponse.text();
  //   throw new Error(`IndexNow request failed: ${indexNowResponse.status} ${indexNowResponse.statusText} - ${errorText}`);
  // }

  // return new Response(JSON.stringify({
  //   message: "IndexNow update submitted successfully.",
  //   count: urlsToAdd.length,
  //   urls: urlsToAdd,
  // }), {
  //   status: 200,
  //   headers: { "Content-Type": "application/json" },
  // });
};

export const config: Config = {
  schedule: "@daily",
};
