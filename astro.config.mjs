// @ts-check
import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import netlify from '@astrojs/netlify';
import preact from '@astrojs/preact';

// https://astro.build/config
export default defineConfig({
  site: 'https://davidjuhasz.dev',
  integrations: [tailwind(), preact()],

  // Adapter needed to handle redirects when deploying to Netlify
  adapter: netlify(),
  redirects: {
    "/blog/sitemap.xml": {
      status: 301,
      destination: "/sitemap.xml"
    },
    "/resume": {
      status: 302,
      destination: "/resume/DavidJuhasz_Resume_2025.pdf",
    },
  },
});
