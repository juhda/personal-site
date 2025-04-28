# Personal Site

This is my personal website, built with [Astro](https://astro.build/).
It serves as my digital home — a place to showcase my portfolio, share ideas, and document my growth as a developer.

## ✨ Features

- ✅ Clean, modern design using Astro + Tailwind CSS
- ✅ Dark mode matching browser/system settings
- ✅ Fully responsive layout
- ✅ SEO-optimized with custom meta and structured data
- ✅ Privacy-respecting analytics via GoatCounter
- ✅ Integrated Notion-powered portfolio view

## 🧠 Goals

- Establish a professional and authentic online presence
- Showcase selected projects and case studies
- Share technical insights and personal learnings

## 🛠️ Tech Stack

- [Astro](https://astro.build/) – Static site framework
- [Tailwind CSS](https://tailwindcss.com/) – Utility-first styling
- [Notion](https://notion.so/) – Embedded portfolio data
- [GoatCounter](https://www.goatcounter.com/) – Lightweight, privacy-first analytics
- [Netlify](https://netlify.com/) – Hosting (free tier)

## 📂 Project Structure

```bash
.
├── public/             # Static assets (favicons, OG images)
├── src/
│   ├── assets/         # Internal static resources (images, fonts, etc.)
│   ├── components/     # Reusable Astro/JSX components (e.g. SEO.astro)
│   ├── config/         # Site-wide configuration (e.g., metadata)
│   ├── layouts/        # Base layout with shared header and structure
│   ├── pages/          # Astro page routes (/index, /portfolio, etc.)
│   ├── styles/         # Tailwind config & custom styles
│   └── utils/          # JavaScript helpers (e.g., breadcrumb generator)
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
- Bring in text content to pages from Markdown
- Integrate blog via Hashnode RSS or API

## 🔗 License

- 🧩 **Code** (everything in `/src`, `/astro.config.mjs`, etc.) is licensed under the [MIT License](./LICENSE).
- ✍️ **Content** (text, articles, written works, and images) is © Dávid Juhász and available under the [Creative Commons Attribution-NonCommercial 4.0 License (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/), unless otherwise noted.

Feel free to fork, adapt, and build upon the code for personal or commercial use.
If you'd like to reuse written content, please reach out to me.
