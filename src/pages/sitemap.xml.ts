import getStaticPaths from '../utils/getStaticPaths';

import sitemapData from '../generated/sitemap-data.json';

export const prerender = false;

export async function GET() {
  const site = import.meta.env.SITE;
  if (!site) {
    return new Response('Sitemap generation failed: site URL is not set in astro.config.mjs.', { status: 500 });
  }

  const urls: string[] = [...sitemapData.staticRoutes];

  for (const modulePath of sitemapData.dynamicModules) {
    const functionName = getStaticPaths.pathToFunctionName(modulePath);

    if (!(functionName in getStaticPaths) || typeof getStaticPaths[functionName as keyof typeof getStaticPaths] !== 'function') {
      console.warn(`[sitemap] Module getStaticPaths does not export a function named ${functionName} for ${modulePath}`);
      continue;
    }

    const fun = getStaticPaths[functionName as keyof typeof getStaticPaths];
    const result = await fun();

    if (!Array.isArray(result)) {
      console.warn(`[sitemap] ${functionName} in getStaticPaths returned invalid result.`);
      continue;
    }

    for (const { params } of result) {
      const param = Object.values(params);
      const url = `${modulePath}/${param}/`;
      urls.push(url);
    }
  }

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls.map(url => `
  <url>
    <loc>${site}${url}</loc>
  </url>`).join('')}
</urlset>`;

  return new Response(xml, {
    headers: {
      'Content-Type': 'application/xml'
    }
  });
}
