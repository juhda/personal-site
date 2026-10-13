# Personal Site

This is my personal website, built with [Astro](https://astro.build/).
It serves as my digital home — a place to showcase my portfolio, share ideas, and document my growth as a developer.

## ✨ Features

- ✅ Clean, modern design using Astro + Tailwind CSS
- ✅ Dark mode matching browser/system settings
- ✅ Fully responsive layout
- ✅ SEO-optimized with custom meta and structured data
- ✅ `robots.txt`, dynamically generated `sitemap.xml`, and [IndexNow](https://indexnow.org) support for URL changes
- ✅ Integrated Notion-powered portfolio view
- ✅ Privacy-respecting analytics via GoatCounter
  - No personal data is collected. Analytics endpoint is public and safe to embed.
- ✅ Optional blog subscription form with redirect pages for double opt-in.
- ✅ Integrated blog with posts authored in [Typst](https://typst.app/)
  - Posts live in-repo under `src/content/blog/<slug>/` (body + metadata + colocated images)
  - Rendered to HTML at build time via [astro-typst](https://github.com/OverflowCat/astro-typst); all blog routes are fully prerendered (static)
  - Listings, tags, series, archives, and client-side search over post metadata

## 🧠 Goals

- Establish a professional and authentic online presence
- Showcase selected projects and case studies
- Share technical insights and personal learnings

## 🛠️ Tech Stack

- [Astro v7](https://astro.build/) – Modern web framework
- [Tailwind CSS v4](https://tailwindcss.com/) – CSS-first utility engine (Vite plugin)
- [Preact](https://preactjs.com/) – Fast 3kB alternative to React for interactive components
- [Notion](https://notion.so/) – Embedded portfolio data source
- [GoatCounter](https://www.goatcounter.com/) – Lightweight, privacy-first analytics
- [Buttondown](https://buttondown.email) – Lightweight newsletter platform used for optional blog post subscriptions
- [Netlify](https://netlify.com/) – Hosting with adapter-based redirect handling (free tier)
- [Typst](https://typst.app/) + [astro-typst](https://github.com/OverflowCat/astro-typst) – Blog authoring format and build-time HTML rendering

## 📂 Project Structure

```bash
.
├── public/               # Static assets (favicons, OG images)
├── scripts/              # JavaScript/TypeScript helpers for static generation
├── src/
│   ├── assets/           # Internal static resources (images, fonts, etc.)
│   ├── blog/             # Blog machinery: content collection queries, colocated image serving/expansion, git-derived dates
│   ├── components/       # Reusable Astro/JSX components (e.g. SEO.astro)
│   ├── config/           # Site-wide configuration (e.g., metadata)
│   ├── content/
│   │   ├── blog/         # Blog posts: <slug>/index.html.typ + meta.yaml + images/
│   │   └── series/       # Series: <slug>/meta.yaml + colocated cover.png
│   ├── layouts/          # Base layout with shared header and structure
│   ├── pages/            # Astro page routes (/index, /portfolio, etc.)
│   ├── styles/           # Tailwind config, themes, and custom styles
│   ├── typst/            # Typst pipeline helpers (hAST post-processing injected into astro-typst)
│   ├── utils/            # JavaScript/TypeScript helpers (e.g., breadcrumb generator)
│   └── content.config.ts # Content Layer configuration (blog + series collections)
└── astro.config.mjs      # Astro site configuration
```

## 🔑 Environment Variables

To enable some features, environment variables need to be defined. Create a `.env` file in the root of your project for local runs and add the variables to your Netlify project config for the published site:

| Variable | Description |
|----------|-------------|
| `INDEXNOW_KEY` | (Optional) The IndexNow verification key used to generate the public verification file and submit changed URLs to IndexNow after each build. |
| `URL` | (Required if `INDEXNOW_KEY` is defined) The deployed site URL used by the IndexNow submission script at build time. Automatically provided by Netlify for deployed sites. |

> **Note:** Without `INDEXNOW_KEY`, IndexNow submission is gracefully skipped.

## 📝 Setup & Development

To run this site locally:

```bash
# 0. Requirements: Node.js >= 22 (declared in package.json engines;
#    also used by Netlify to select the build runtime)
#    The post-build IndexNow script uses the native Set.symmetricDifference.

# 1. Clone the repository
$ git clone https://github.com/juhda/personal-site.git
$ cd your-repo-name
# (Replace with your own repo URL)

# 2. Install dependencies
$ npm install

# 3. Start the development server
$ npm run dev

# The site will be available at http://localhost:4321
```

### 💡 Development Notes

- **Environment Variables:** The dev server will automatically load variables from a `.env` file in the root directory if it exists.
- **Drafts:** Set `draft: true` in a post's `meta.yaml` to hide it from the published site (omitted, `draft` defaults to `false`). Draft posts appear in `astro dev` and Netlify branch deploy previews at `/blog/drafts/<slug>` only — never at their post URL or on published surfaces; production builds exclude them entirely.

## 🚀 Deployment

This project is deployed to [Netlify](https://netlify.com/).
To deploy your own version:

1. Push the repo to GitHub (or your preferred Git provider).
2. Customize the site and update your content.
   - Update the metadata in `src/config/site.ts`
   - Update the analytics URL (`goatCounterUrl`) if using GoatCounter, or remove analytics setup from `BaseLayout.astro`
3. Create a new site in Netlify and link it to your repo.
4. Set the build command to `npm run build` and publish directory to `dist`.
5. Netlify will auto-deploy on every push.

Alternatively, you can export and host the static files yourself:

```bash
$ npm run build
$ npx serve dist
```

## 🚦 Redirects Handling

This project uses Astro's built-in `redirects` configuration to manage server-side redirects, such as automatically sending users from `/resume` to the latest resume PDF.

- Redirect rules are defined in `astro.config.mjs` under the `redirects` map.
- Local development (`npm run dev`) handles redirects dynamically.
- During production builds (`npm run build`), the [Netlify adapter](https://docs.astro.build/en/guides/integrations-guide/netlify/) automatically generates a `_redirects` file inside the `dist/` folder based on this configuration.
- The static hosting platform (Netlify) then applies these redirects at the server level for fast and seamless navigation.

### How to Add or Update Redirects

1. Open `astro.config.mjs`.
2. Find or add the `redirects` map.
3. Define each redirect with this structure:
   ```js
   redirects: {
     '/old-path': {
       status: 301,
       destination: '/new-path'
     },
     '/resume': {
       status: 302,
       destination: '/resume/Your_Actual_Resume.pdf'
     },
   }
   ```
   - *key*: The URL visitors will access.
   - `destination`: The destination path or resource.
   - `status`: The HTTP status code (`301` for permanent, `302` for temporary redirects).
4. Save your changes and rebuild the project for deployment.
   - No manual `_redirects` file is needed.

## 🌐 Sitemap Generation

The `sitemap.xml` is generated statically at build time. Since all blog content lives in the repository, every route is known at build, resolved from the content collections, and prerendered. Pages marked `noindex` — the blog listing, tags, archives, search, and drafts pages — are excluded; the indexed routes are the static pages, posts (`/blog/[slug]`), and series detail pages (`/blog/series/[series_name]`).

### ⚙️ How it works

- `scripts/generate-sitemap-data.ts` runs during both build and dev to:
  - Traverse `src/pages/`
  - Collect all static routes
  - Identify dynamic route modules
  - Skip static and dynamic pages that are marked with `noindex={true}` in their layout usage so they are excluded from the sitemap
  - Add `sitemapAdditionalUrls` from `src/config/site.ts` to static routes
  - Save them to `src/generated/sitemap-data.json`
- Dynamic route logic lives in `src/utils/getStaticPaths.ts` with named exports like `getStaticPaths_blog()`
  - Each dynamic `.astro` page imports its matching function for `getStaticPaths`
- `src/pages/sitemap.xml.ts` is prerendered: it reads the generated JSON file, resolves dynamic paths from the content collections at build time, and emits a static `sitemap.xml`

Because both the route list and the `noindex` flags are resolved from the same sources at build time, the sitemap always matches what the build actually produces.

## 🔍 IndexNow Support

This site can submit changed URLs to [IndexNow](https://www.indexnow.org/) so search engines can discover updates faster.

### How it works

- A verification file required by IndexNow is generated by `scripts/generate-indexnow-key-file.ts` into the `public/` directory during build.
- After each build, `scripts/submit-indexnow.mjs` compares the freshly built `sitemap.xml` against the currently deployed (live) sitemap — which is the previous deploy's URL set — and submits the changed URLs (added and removed) to IndexNow.
- The live sitemap is the baseline, so no state needs to be stored: if a deploy fails after submission, the next build re-detects and re-submits the same diff.
- Transient submission failures (network errors, 5xx) are retried up to 3 times with backoff. A 4xx (usually a bad key) is not retried.

### Limitation

- The submission is best effort — no persistent state. If a submission still fails after the retries, the deploy publishes normally and the pages remain live and crawlable via `sitemap.xml`, but the accelerated IndexNow notification for them is lost (the next deploy's baseline already contains them). Manual recovery at any time:
  ```bash
  npm run build && npm run submit:indexnow -- --all
  ```
  `--all` resubmits every URL in the built sitemap, ignoring the baseline.
- The script does not check content updates at existing URLs.
  - This could be added if `sitemap.xml` provided `lastmod` values for URLs.

### Required setup

To enable IndexNow support, make sure the following environment variables are configured:

```bash
INDEXNOW_KEY=your-indexnow-key
URL=https://your-domain.com
```

> **Note:** The environment variable `URL` is provided by Netlify automatically for deployments.

## 📰 Blog

Blog posts are authored in [Typst](https://typst.app/) and live in this repository, rendered to HTML at build time via [astro-typst](https://github.com/OverflowCat/astro-typst). All blog routes are prerendered (fully static).

### Content layout

```
src/content/blog/
  _preamble.typ            # shared rendering definitions (imported by posts)
  <slug>/
    index.html.typ         # post body (Typst)
    meta.yaml              # title, subtitle, description, seoTitle?,
                           # publishedAt?, updatedAt?, tags (slugs), series?,
                           # coverImage?, ogImage?, draft?
    images/                # colocated images, served flat at /content/blog/<slug>/
src/content/series/<slug>/
  meta.yaml                # series name, description, coverImage
  cover.png                # served at /content/series/<slug>/cover.png
src/content/tags.yaml      # tag display names (slug -> name list)
```

Cover and OG images are named `cover.png` / `og.png`. Inline images are referenced by their filename (`#blog-img("Foo.png")`), which must match the file in the post's `images/` directory. Prefer filenames without spaces (`My-Diagram.png`) since the name is also the served URL.

### Dates and tags

- **Dates**: `publishedAt` and `updatedAt` are optional in `meta.yaml`. When omitted, the content loader derives them from git at build time — `publishedAt` from the first commit that added the post directory, `updatedAt` from the last commit that touched it. Explicit `meta.yaml` values always win. New posts can simply omit both. Git-derived dates require the build to have git history (Netlify provides a full clone); uncommitted posts have no dates until first commit.
- **Tags**: posts list tag **slugs** only. Display names live once in `src/content/tags.yaml` (a list of `slug`/`name` pairs). A slug whose name equals the slug can be omitted, and a slug without an entry simply displays as the slug itself — so most tags need no entry at all.
- **Series**: `series` in `meta.yaml` links a post to a series; omitted (or null) means a standalone post.
- **Drafts**: `draft` defaults to `false` when omitted — a post is a draft only if explicitly flagged `draft: true`. A minimal starting point lives at `src/content/blog/template/` (a draft; copy the directory and replace its contents).

### Rendering pipeline

- `index.html.typ` is compiled by astro-typst (typst.ts WASM compiler) to semantic HTML; the post pages wrap it in `<article>` so the `article`-scoped styles apply.
- Shared rendering definitions live in `src/content/blog/_preamble.typ` (`blog-img` emits plain `<img>` with site-relative URLs; `horizontalrule` emits `<hr>` — a markdown-style thematic break with no Typst equivalent, so the definition has to exist somewhere; `callout` is the block-quote helper for callout boxes — `quote()` defaults to an inline quote, so `block: true` is load-bearing and the alias keeps post sources short). Each post imports it:
  ```
  #import "../_preamble.typ": blog-img, horizontalrule, callout
  ```
- `src/typst/rehype-typst.mjs` post-processes the emitted hAST inside astro-typst's compile pipeline (injected by the `typstBridged` wrapper in `astro.config.mjs`).
- `src/blog/images.mjs` is a vite plugin handling colocated images end to end: its `load` hook expands bare image filenames in the `.typ` source (`#blog-img("Foo.png")` becomes the served URL `/content/blog/<slug>/Foo.png`) before astro-typst compiles the post, its dev middleware serves the images from the source tree, and at build it copies them into `dist/content/`.
- Code blocks are syntax-highlighted by Typst at build time.

### Notes and limitations

- Publishing a post = committing it and pushing; the site rebuilds (~1–2 min on Netlify).
- Math: Typst's HTML export currently drops formula content silently (experimental feature as of Typst 0.14.2); equation labels and `@`-references still render (as an anchor and a numbered link), so cross-references keep working while the formulas themselves are invisible. If you need visible math, wait for upstream support or raise it before writing a math-heavy post. The template post demonstrates inline, block, and numbered equations.
- The **Search page** is linked in blog pages only if the number of posts meets or exceeds the configured `blogSearchLimit` in the global config (`/src/config/site.ts`); the page includes all posts and performs client-side filtering.
- The **Subscribe page** is linked only if `blogSubscribeAction` is defined in the global config.
- **Drafts**: posts with `draft: true` in `meta.yaml` are excluded from production builds entirely; they appear in `astro dev` and Netlify branch deploy previews at `/blog/drafts`.

## ✉️ Subscription Support

This site includes **optional newsletter subscription support**.

- A subscribe form is rendered at `/blog/subscribe`
- When configured, readers can subscribe by submitting the form
- Branded success and confirmation pages are defined at:
  - `/blog/subscribe/pending`
  - `/blog/subscribe/confirmed`

### 🔧 Configuration

Newsletter support is enabled via the following config options in `src/config/site.ts`:

| Option | Description |
|--------|-------------|
| `blogSubscribeAction` | If set, enables the subscription form and submission logic |
| `blogSubscribeNameField` | Optional label for a name input to personalize messages |

## 🎨 Code Block Enhancements

This site enhances the appearance and functionality of code blocks within blog posts by adding language indicators and copy buttons.

- **Automatic Language Detection**: The script automatically detects the programming language of each code block by examining the class attribute of the `<code>` element. It looks for patterns like `language-(\w+)` or `lang-(\w+)` to extract the language name. If a match is found, the language name is displayed in a styled span element within the code block header. If no match is found, the language indicator is skipped for that code block.
- **Copy Button**: Allows users to easily copy the code block content to the clipboard.

### 📦 Implementation Notes

- The enhancement is implemented in `src/components/CodeblockEnhancer.astro`.
- The script adds a header with the additional elements for a `<code>` element when the element is the only directly child of a `<pre>` element.
- The script is injected into the post pages (`src/pages/blog/[slug].astro` and `src/pages/blog/drafts/[slug].astro`) using Astro's `<Fragment slot="head">`.

## 📌 Customization Tips

- Adjust site config at `src/config/site.ts` and content in pages in `src/pages`
- Add new pages in `src/pages/`
- Modify `BaseLayout.astro` to change site-wide structure and metadata defaults
- Update Tailwind config to match your personal color palette
- Update `SEO.astro` and `getBreadcrumbList()` for structured data enhancements
- Use named colors (like `text-primary`, `bg-surface`, `border-muted`) in your Tailwind classes for consistency and easier theme customization

## 🔮 Future Ideas

- Dark mode toggle with default to follow system
- Use Tailwind `prose` for unified professional typography


## 🔗 License

- 🧩 **Code** (everything in `/src`, `/astro.config.mjs`, etc.) is licensed under the [MIT License](./LICENSE).
- ✍️ **Content** (text, articles, written works, and images) is © Dávid Juhász and available under the [Creative Commons Attribution-NonCommercial 4.0 License (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/), unless otherwise noted.

Feel free to fork, adapt, and build upon the code for personal or commercial use.
If you'd like to reuse written content, please reach out to me.
