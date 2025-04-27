// @ts-check
import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import sitemap from '@astrojs/sitemap';
import netlify from '@astrojs/netlify';

// https://astro.build/config
export default defineConfig({
  site: 'https://davidjuhasz.dev',
  integrations: [tailwind(), sitemap()],

  // Enable configured redirects only when your host supports dynamic routing.
  // For static hosts, use public/_redirects instead, and keep this option disabled.
  // NOTE: Keep the list in sync with public/_redirects!
  adapter: netlify(),
  redirects: {
    "/resume": {
      status: 302,
      destination: "/resume/DavidJuhasz_Resume_2025.pdf",
    },
  },
});
