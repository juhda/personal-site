import fs from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { sitemapAdditionalUrls } from '../src/config/site';

import getStaticPaths from '../src/utils/getStaticPaths';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const PAGES_DIR = path.resolve(__dirname, '../src/pages');
const OUTPUT_PATH = path.resolve(__dirname, '../src/generated/sitemap-data.json');

async function main() {
  const staticRoutes: string[] = [];
  const dynamicModules: string[] = [];

  async function walk(dir: string) {
    const entries = await fs.readdir(dir, { withFileTypes: true });

    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      const relPath = path.relative(PAGES_DIR, fullPath);
      const parsed = path.parse(relPath);

      if (entry.isDirectory()) {
        await walk(fullPath);
        continue;
      }

      if (parsed.ext !== '.astro') continue;

      const isDynamic = /^\[.+\]$/.test(parsed.name);

      if (isDynamic) {
        const modulePath = `/${parsed.dir}`;
        if (dynamicModules.includes(modulePath)) {
          throw new Error(`[sitemap] Duplicate dynamic module detected: ${modulePath}`);
        }
        const functionName = getStaticPaths.pathToFunctionName(modulePath);
        if (!(functionName in getStaticPaths) || typeof getStaticPaths[functionName as keyof typeof getStaticPaths] !== 'function') {
          throw new Error(`[sitemap] Module getStaticPaths does not export a function named ${functionName} for ${modulePath}`);
        }
        dynamicModules.push(modulePath);
      } else {
        const isIndex = parsed.name === 'index';
        const routePath = `/${parsed.dir}${parsed.dir !== '' ? '/' : ''}`;
        let route = `${routePath}${isIndex ? '' : (parsed.name + '/')}`;
        staticRoutes.push(route);
      }
    }
  }

  await walk(PAGES_DIR);

  const userUrls = sitemapAdditionalUrls;

  const data = {
    staticRoutes: [...new Set([...staticRoutes, ...userUrls])],
    dynamicModules: dynamicModules.sort()
  };

  await fs.mkdir(path.dirname(OUTPUT_PATH), { recursive: true });
  await fs.writeFile(OUTPUT_PATH, JSON.stringify(data, null, 2), 'utf-8');

  console.log(`[sitemap] Wrote sitemap-data.json with ${data.staticRoutes.length} static and ${data.dynamicModules.length} dynamic modules`);
}

main().catch(err => {
  console.error('[sitemap] Failed to generate sitemap data:', err);
  process.exit(1);
});
