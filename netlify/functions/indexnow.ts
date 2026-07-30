import type { Config } from "@netlify/functions";
import { XMLParser } from "fast-xml-parser";

interface SitemapUrlEntry {
  loc: string;
  lastmod?: string | null;
}

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

  const rawUrls = urlset.url ?? [];


  const urlEntries: SitemapUrlEntry[] = Array.isArray(rawUrls)
    ? rawUrls
    : [rawUrls];

  console.log(urlEntries);

  // const thresholdMs = nextRun.valueOf() - 24 * 60 * 60 * 1000;
  // const parsedEntries = urlEntries
  //   .map((entry) => ({
  //     loc: entry.loc?.trim?.() ?? "",
  //     lastmod: entry.lastmod?.trim?.() ?? null,
  //   }))
  //   .filter((entry) => entry.loc)
  //   .map((entry) => {
  //     const lastmodDate = entry.lastmod ? new Date(entry.lastmod) : null;
  //     return {
  //       loc: entry.loc,
  //       lastmodDate: lastmodDate && !Number.isNaN(lastmodDate.valueOf()) ? lastmodDate : null,
  //     };
  //   });

  // const allUrls = parsedEntries.map((entry) => entry.loc);
  // const changedUrls = parsedEntries
  //   .filter((entry) => (entry.lastmodDate?.valueOf() ?? 0) > thresholdMs)
  //   .map((entry) => entry.loc);

  // const hasLastmodData = parsedEntries.some((entry) => entry.lastmodDate !== null);
  // const urlsToSubmit = hasLastmodData ? changedUrls : allUrls;

  // if (urlsToSubmit.length === 0) {
  //   console.log("IndexNow update: no URLs changed since the last run.");
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
  //     urlList: urlsToSubmit,
  //   }),
  // });

  // if (!indexNowResponse.ok) {
  //   const errorText = await indexNowResponse.text();
  //   throw new Error(`IndexNow request failed: ${indexNowResponse.status} ${indexNowResponse.statusText} - ${errorText}`);
  // }

  // return new Response(JSON.stringify({
  //   message: "IndexNow update submitted successfully.",
  //   count: urlsToSubmit.length,
  //   urls: urlsToSubmit,
  // }), {
  //   status: 200,
  //   headers: { "Content-Type": "application/json" },
  // });
};

export const config: Config = {
  schedule: "@daily",
};
