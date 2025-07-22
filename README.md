# Personal Site

This is my personal website, built with [Astro](https://astro.build/).
It serves as my digital home — a place to showcase my portfolio, share ideas, and document my growth as a developer.

## ✨ Features

- ✅ Clean, modern design using Astro + Tailwind CSS
- ✅ Dark mode matching browser/system settings
- ✅ Fully responsive layout
- ✅ SEO-optimized with custom meta and structured data
- ✅ `robots.txt` and dynamically generated `sitemap.xml`
- ✅ Integrated Notion-powered portfolio view
- ✅ Privacy-respecting analytics via GoatCounter
  - No personal data is collected. Analytics endpoint is public and safe to embed.
- ✅ Optional blog subscription form with redirect pages for double opt-in.
- ✅ Integrated blog via [Hashnode](https://hashnode.com/)
  - Uses the official GraphQL API to fetch blog metadata and posts
  - Renders dynamic routes (`/blog/[slug]`) and listing pages (`/blog/tags`, `/blog/series`, etc.)
  - All blog pages are server-rendered on demand without caching or prerendering; suitable for low traffic, with the option to add caching later

## 🧠 Goals

- Establish a professional and authentic online presence
- Showcase selected projects and case studies
- Share technical insights and personal learnings

## 🛠️ Tech Stack

- [Astro](https://astro.build/) – Static site framework
- [Tailwind CSS](https://tailwindcss.com/) – Utility-first styling
- [Notion](https://notion.so/) – Embedded portfolio data
- [GoatCounter](https://www.goatcounter.com/) – Lightweight, privacy-first analytics
- [Buttondown](https://buttondown.email) – Lightweight newsletter platform used for optional blog post subscriptions
- [Netlify](https://netlify.com/) – Hosting (free tier)
- [Hashnode GraphQL API](https://hashnode.com/) – Blog content source

## 📂 Project Structure

```bash
.
├── public/             # Static assets (favicons, OG images)
├── scripts/            # JavaScript/TypeScript helpers for static generation
├── src/
│   ├── assets/         # Internal static resources (images, fonts, etc.)
│   ├── components/     # Reusable Astro/JSX components (e.g. SEO.astro)
│   ├── config/         # Site-wide configuration (e.g., metadata)
│   ├── hashnode-lib/   # GraphQL client definitions to fetch blog data
│   ├── layouts/        # Base layout with shared header and structure
│   ├── pages/          # Astro page routes (/index, /portfolio, etc.)
│   ├── styles/         # Tailwind config & custom styles
│   └── utils/          # JavaScript/TypeScript helpers (e.g., breadcrumb generator)
└── astro.config.mjs    # Astro site configuration
└── tailwind.config.mjs # Tailwind site configuration
```

## 📝 Setup & Development

To run this site locally:

```bash
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

This project uses Astro’s built-in `redirects` configuration to manage server-side redirects, such as automatically sending users from `/resume` to the latest resume PDF.

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

This project includes dynamic sitemap generation to ensure that all relevant pages — including those rendered with on-demand rendering — are accurately included in `sitemap.xml`. This supports better SEO indexing, even for dynamic routes that aren't prerendered at build time.

### 🧠 Why it's needed

Astro's default sitemap plugin only includes statically generated pages. Since this site uses on-demand rendering (ODR) for blog content, we generate the sitemap ourselves to include:
- Static pages (e.g. /about, /portfolio)
- Dynamic pages (e.g. /blog/[slug], /blog/tags/[tag]) by running getStaticPaths() at runtime

### ⚙️ How it works

- `scripts/generate-sitemap-data.ts` runs during both build and dev to:
  - Traverse `src/pages/`
  - Collect all static routes
  - Add `sitemapAdditionalUrls` from `src/config/site.ts` to static routes
  - Identify dynamic route modules
  - Save them to `src/generated/sitemap-data.json`
- Dynamic route logic lives in `src/utils/getStaticPaths.ts` with named exports like `getStaticPaths_blog()`
  - Each dynamic `.astro` page imports its matching function for `getStaticPaths`
- `src/pages/sitemap.xml.ts` reads the generated JSON file and calls these functions to build a live `sitemap.xml` at runtime

This approach works with any server adapter (static or SSR) and ensures the sitemap is always up-to-date when dynamic rendering is supported.

## 📰 Blog Integration (Hashnode)

This site integrates with [Hashnode](https://hashnode.com/) as a headless blog source using their public GraphQL API.

- Dynamic blog pages are generated under `/blog` (e.g. `/blog/my-article`)
- Blog content is fetch dynamically and blog pages are created with Astro's [on-demand rendering](https://docs.astro.build/en/guides/on-demand-rendering/)
- The integration handles posts (respecting canonical URL if defined in Hashnode), tags, and series
- GraphQL queries are modular, using fragments and clean types
- Blog descriptions and metadata are rendered using trusted HTML from Hashnode and safely injected with Astro’s `set:html`
- LaTeX math content is conditionally rendered using MathJax (see below)

### Implementation Notes

- On-Demand Rendering
  - Blog pages are rendered dynamically on every request — prerendering is disabled for all blog routes
  - No server-side caching is configured via the Netlify adapter; each page request fetches fresh content from the Hashnode API
  - This is acceptable for low-traffic use, but traffic levels should be monitored and caching configured if request volume increases
- Hashnode API and Features
  - Posts are displayed in the order returned by Hashnode’s API — newest first by default, though series may use oldest-first sorting depending on settings
  - Blog post slugs are matched directly — no post redirect support is implemented
  - Not all metadata (e.g. author bios, reactions, visibility flags) from Hashnode is used
  - No static pages and custom redirects from Hashnode are handled — implement any static content and redirects directly with Astro
  - Reactions and commenting are not supported, as Hashnode does not expose interaction features in headless mode
- Conditional Navigation Items
  - The **Search page** is linked in blog pages only if the number of posts meets or exceeds the configured `blogSearchLimit` in the global config (`/src/config/site.ts`)
    - The page includes all posts and performs client-side filtering
  - The **Subscribe page** is active and linked in blog pages only if `blogSubscribeAction` is defined in the global config (`/src/config/site.ts`)

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


## ➕ MathJax Support for LaTeX (Optional)

This site optionally supports LaTeX-style math rendering via [MathJax](https://www.mathjax.org/), which is also used by Hashnode for embedded math expressions.

- Inline math uses `$...$`, and block math uses `$$...$$`.
- MathJax is **only enabled if `blogEnableMath` is set to `true`** in the global config (`src/config/site.ts`)
- When enabled, MathJax is loaded **dynamically and only when math is detected** in post content or previews
  - Pages pass `content` (e.g. a post’s `html` or `brief`) into `MathJaxLoader`.
  - The loader component scans for LaTeX syntax and conditionally injects the MathJax script.
  - This works on both full post pages (`/blog/[slug]`) and previews (`/blog`, `/blog/tags`, etc.).
- `MathJaxLoader` is injected into pages using Astro's `<Fragment slot name="head">`.

### ✍️ To use math in a post

To include math, when math rendering is enabled, write LaTeX in your Hashnode post using:

```latex
$...$       // for inline math
$$...$$     // for block math
\$          // for a literal dollar sign
```

Math will render automatically wherever it's used in post content or previews.

### 📦 Implementation Notes

- Math rendering is globally enabled/disabled for blog posts and previews by `blogEnableMath` in `src/config/site.ts`.
- Uses [MathJax v3](https://www.mathjax.org/#gettingstarted) from CDN with the default `tex-mml-chtml` loader.
- Configuration and conditional loading are handled in `src/components/MathJaxLoader.astro`.
- No MathJax code is loaded on pages that don’t include LaTeX syntax — for optimal performance.

## 🎨 Highlight.js Support for Syntax Highlighting (Optional)

This site supports syntax highlighting for code blocks via [Highlight.js](https://highlightjs.org/). The HTML content fetched from Hashnode is already preprocessed with Highlight.js, so no additional JavaScript is required. However, you can optionally include the Highlight.js stylesheet for proper rendering of the syntax-highlighted code.

- Syntax highlighting is applied to code blocks within `<pre><code>` tags and includes `hljs` classes.
- Highlight.js styles are **only enabled if `blogEnableSyntaxHighlighting` is set to `true`** in the global config (`src/config/site.ts`).
- When enabled, Highlight.js is stylesheet is loaded dynamically.
  - Pages pass `content` (e.g., a post's `html` or `brief`) into `HighlightJSLoader`.
  - The loader component scans for `hljs` classes and conditionally injects the Highlight.js stylesheet.
  - This works on both full post pages (`/blog/[slug]`) and previews (`/blog`, `/blog/tags`, etc.).
- `HighlightJSLoader` is injected into pages using Astro's `<Fragment slot="head">`.

### 🔧 Configuration Details

When math rendering is enabled:

- MathJax is configured to recognize `$...$` (inline) and `$$...$$` (block) math
- Escaped dollar signs (`\$`) are treated as literal dollar symbols (`processEscapes: true`)
- Content inside `<pre>`, `<code>`, `<style>`, etc., is safely ignored
- The configuration is injected before MathJax loads in `src/components/MathJaxLoader.astro`

If math rendering is disabled via `blogEnableMath = false`, no MathJax scripts or config are included, and dollar signs will be displayed as-is.

## 🎨 Code Block Enhancements (Optional)

This site includes an optional feature to enhance the appearance and functionality of code blocks within blog posts. When enabled, this feature adds language indicators and copy buttons to code blocks.

- **Automatic Language Detection**: The script automatically detects the programming language of each code block by examining the class attribute of the `<code>` element. It looks for patterns like `language-(\w+)` or `lang-(\w+)` to extract the language name. If a match is found, the language name is displayed in a styled span element within the code block header. If no match is found, the language indicator is skipped for that code block.
- **Copy Button**: Allows users to easily copy the code block content to the clipboard.

### 📦 Implementation Notes

- Only enabled if `blogEnhanceCodeblocks` is set to `true` in the global config (`src/config/site.ts`).
- The enhancement is implemented in `src/components/CodeblockEnhancer.astro`.
- The script adds a header with the additional elements for a `<code>` element when the element is the only directly child of a `<pre>` element.
- The script is injected into `src/pages/blog/[slug].astro` using Astro's `<Fragment slot="head">`.

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
- Bring in text content to static and blog pages from Markdown
- Improve blog integration
  - Configure caching reasonable policies if request volume increases
  - Optimize GraphQL queries if needed to reduce latency and request frequency under higher load


## 🔗 License

- 🧩 **Code** (everything in `/src`, `/astro.config.mjs`, etc.) is licensed under the [MIT License](./LICENSE).
- ✍️ **Content** (text, articles, written works, and images) is © Dávid Juhász and available under the [Creative Commons Attribution-NonCommercial 4.0 License (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/), unless otherwise noted.

Feel free to fork, adapt, and build upon the code for personal or commercial use.
If you'd like to reuse written content, please reach out to me.
