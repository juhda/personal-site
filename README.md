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
- [GoatCounter](https://www.goatcounter.com/) – Lightweight, privacy-first analytics
- [Notion](https://notion.so/) – Embedded portfolio data
- [Netlify](https://netlify.com/) – Hosting (free tier)

## 📂 Project Structure

```bash
.
├── public/             # Static assets (favicons, OG images)
├── src/
│   ├── components/     # Reusable Astro/JSX components (e.g. SEO.astro)
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
$ git clone https://github.com/yourusername/your-repo-name.git
$ cd your-repo-name

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
2. Create a new site in Netlify and link it to your repo.
3. Set the build command to `npm run build` and publish directory to `dist`.
4. Netlify will auto-deploy on every push.

Alternatively, you can export and host the static files yourself:

```bash
$ npm run build
$ npx serve dist
```

## 📌 Customization Tips

- Modify `BaseLayout.astro` to change site-wide structure and metadata defaults
- Add new pages in `src/pages/`
- Update Tailwind config to match your personal color palette
- Update `SEO.astro` and `getBreadcrumbList()` for structured data enhancements
- Use named colors (like `text-primary`, `bg-surface`, `border-muted`) in your Tailwind classes for consistency and easier theme customization

## 🔮 Future Plans

- Integrate blog via Hashnode RSS or API

## 🔗 License

- 🧩 **Code** (everything in `/src`, `/public`, `/astro.config.mjs`, etc.) is licensed under the [MIT License](./LICENSE).
- ✍️ **Content** (text, articles, and written works) is © Dávid Juhász and available under the [Creative Commons Attribution-NonCommercial 4.0 License (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/), unless otherwise noted.

Feel free to fork, adapt, and build upon the code for personal or commercial use.
If you'd like to reuse written content, please reach out to me.
