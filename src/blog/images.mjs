// Serves blog images colocated under src/content/ at the /content/... URLs
// that posts and series reference. Post images are organized in an images/
// subdirectory in the source but served flat next to the post, symmetric
// with series covers:
//   src/content/blog/<slug>/images/x.png  -> /content/blog/<slug>/x.png
//   src/content/series/<slug>/cover.png   -> /content/series/<slug>/cover.png
//
// Build: copies into dist/ (closeBundle). Dev: middleware serves from source.

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "../..");

const CONTENT_DIR = path.join(root, "src/content");
const BLOG_DIR = path.join(CONTENT_DIR, "blog");
const SERIES_DIR = path.join(CONTENT_DIR, "series");

const IMAGE_EXTENSIONS = new Set([".png", ".jpg", ".jpeg", ".gif", ".svg", ".webp", ".avif"]);

const MIME_TYPES = {
  ".png": "image/png", ".jpg": "image/jpeg", ".jpeg": "image/jpeg",
  ".gif": "image/gif", ".svg": "image/svg+xml", ".webp": "image/webp",
  ".avif": "image/avif",
};

/** Map a URL path under /content to an image file on disk, or null.
 *  Only image files under src/content/blog or src/content/series are served. */
function resolveFile(urlPath) {
  const rel = decodeURIComponent(urlPath.replace(/^\/+/, "").replace(/^content\//, ""));
  const parts = rel.split("/");
  let file = null;
  if (parts[0] === "blog" && parts.length === 3) {
    // /content/blog/<slug>/<file> -> src/content/blog/<slug>/images/<file>
    file = path.join(BLOG_DIR, parts[1], "images", parts[2]);
  } else if (parts[0] === "series" && parts.length === 3) {
    // /content/series/<slug>/<file>
    file = path.join(SERIES_DIR, parts[1], parts[2]);
  }
  if (!file) return null;
  if (!file.startsWith(BLOG_DIR) && !file.startsWith(SERIES_DIR)) return null; // traversal guard
  if (!IMAGE_EXTENSIONS.has(path.extname(file).toLowerCase())) return null;
  if (fs.existsSync(file) && fs.statSync(file).isFile()) return file;
  return null;
}

export function images() {
  return {
    name: "content-images",

    // Posts reference inline images by bare filename
    // (#blog-img("Container_Tooling.png", ...)). Expand them to the served
    // URL based on the post's directory (the id tells us the slug) before
    // astro-typst compiles the file. Done in the load hook: astro-typst's
    // load is a no-op, so ours (which returns content) unconditionally wins
    // over vite's built-in file loader — no plugin ordering involved.
    // Idempotent: already-expanded srcs (containing "/") are left untouched.
    load(id) {
      const cleanId = id.split("?")[0];
      const m = cleanId.match(/\/src\/content\/blog\/([^/]+)\/index\.html\.typ$/);
      if (!m) return;
      const code = fs.readFileSync(cleanId, "utf8");
      const base = `/content/blog/${m[1]}/`;
      return code.replace(/(blog-img\(")([^"/*?]+)(")/g, `$1${base}$2$3`);
    },

    closeBundle() {
      const dist = path.join(root, "dist/content");

      // Post images: blog/<slug>/images/* -> content/blog/<slug>/*
      for (const entry of fs.readdirSync(BLOG_DIR, { withFileTypes: true })) {
        if (!entry.isDirectory()) continue;
        const imagesDir = path.join(BLOG_DIR, entry.name, "images");
        if (!fs.existsSync(imagesDir)) continue;
        fs.cpSync(imagesDir, path.join(dist, "blog", entry.name), { recursive: true });
      }

      // Series covers: series/<slug>/<image files> -> content/series/<slug>/
      if (fs.existsSync(SERIES_DIR)) {
        for (const entry of fs.readdirSync(SERIES_DIR, { withFileTypes: true })) {
          if (!entry.isDirectory()) continue;
          const seriesDir = path.join(SERIES_DIR, entry.name);
          const to = path.join(dist, "series", entry.name);
          for (const file of fs.readdirSync(seriesDir)) {
            if (!IMAGE_EXTENSIONS.has(path.extname(file).toLowerCase())) continue;
            fs.mkdirSync(to, { recursive: true });
            fs.cpSync(path.join(seriesDir, file), path.join(to, file));
          }
        }
      }
    },
    configureServer(server) {
      server.middlewares.use((req, res, next) => {
        if (!req.url || !req.url.startsWith("/content/")) return next();
        const u = new URL(req.url, "http://localhost");
        const file = resolveFile(u.pathname);
        if (!file) return next();
        const ext = path.extname(file).toLowerCase();
        res.setHeader("Content-Type", MIME_TYPES[ext] ?? "application/octet-stream");
        fs.createReadStream(file).pipe(res);
      });
    },
  };
}
