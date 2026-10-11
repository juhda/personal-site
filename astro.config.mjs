// @ts-check
import { defineConfig } from 'astro/config';
import netlify from '@astrojs/netlify';
import preact from '@astrojs/preact';
import { typst } from 'astro-typst';

import tailwindcss from '@tailwindcss/vite';
import { rehypeTypstHtml } from './src/typst/rehype-typst.mjs';
import { resolvePostImages } from './src/typst/resolve-post-images.mjs';
import { images } from './src/blog/images.mjs';

const typstIntegration = typst();

// rehypeTypstHtml is a unified/rehype plugin that post-processes the HTML AST
// astro-typst's compile pipeline produces; the only registration channel
// astro-typst 0.12.4 (latest published) exposes is the deprecated
// `markdown.rehypePlugins` key on the stored Astro config. The site has no
// markdown content, so instead of carrying the plugin through Astro's
// markdown config, inject it into the config astro-typst stores in its
// `astro:config:done` hook — after Astro's validation, so the deprecation
// warning never fires.
const typstBridged = {
  ...typstIntegration,
  hooks: {
    ...typstIntegration.hooks,
    'astro:config:done': (options) => {
      options.config.markdown.rehypePlugins = [rehypeTypstHtml];
      return typstIntegration.hooks['astro:config:done'](options);
    },
  },
};

// https://astro.build/config
export default defineConfig({
  site: 'https://davidjuhasz.dev',
  integrations: [preact(), typstBridged],

  // Adapter needed to handle redirects when deploying to Netlify
  adapter: netlify(),

  redirects: {
    "/blog/sitemap.xml": {
      status: 301,
      destination: "/sitemap.xml"
    },
    "/resume": {
      status: 302,
      destination: "/resume/DavidJuhasz_Resume_2026.pdf",
    },
  },

  vite: {
    plugins: [tailwindcss(), images(), resolvePostImages()],
    ssr: {
      external: ["@myriaddreamin/typst-ts-node-compiler"],
    },
  },
});
