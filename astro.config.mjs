// @ts-check
import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import sitemap from '@astrojs/sitemap';

// https://astro.build/config
export default defineConfig({
  site: 'https://davidjuhasz.dev',
  integrations: [tailwind(), sitemap()],
  redirects: {
    "/resume": "/resume/DavidJuhasz_Resume_2025.pdf",
  }
});
