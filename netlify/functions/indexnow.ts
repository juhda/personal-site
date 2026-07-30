import type { Config } from "@netlify/functions";

export default async (req: Request) => {
  const { next_run } = await req.json();

  console.log(`IndexNow update. Next run: ${next_run}`);

  const site = process.env.SITE_URL!;
  const sitemap = await fetch(`${site}/sitemap.xml`);

  if (!sitemap.ok) {
    throw new Error(`Failed to fetch sitemap: ${sitemap.status}`);
  }

  const xml = await sitemap.text();

  // TODO: Implement the logic to parse the XML, determine changed URLs, and POST to IndexNow.
};

export const config: Config = {
  schedule: "@daily",
};
