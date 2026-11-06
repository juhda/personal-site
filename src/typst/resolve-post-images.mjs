// Post-transform for astro-typst compiled Typst modules (blog posts and
// static page bodies). Content references inline images by bare filename
// (#blog-img("Foo.png")); the site expands them to the served URL (images
// are organized in an images/ subdirectory in the source but served flat
// next to the content):
//   src/content/blog/<slug>/images/<name>  ->  /content/blog/<slug>/<name>
// The same resolution applies to page bodies under src/content/pages/
// (which currently colocate no images, so the pattern is future-proofing).
//
// The slug cannot be recovered inside rehypeTypstHtml (astro-typst passes
// the hast to the rehype pipeline without the source file), but a vite
// post-transform sees both the generated module code and its file id, so
// the rewrite happens here, after astro-typst's (enforce: 'pre') transform.
//
// Matches only bare filenames (no "/", no URL scheme), so absolute and
// remote srcs pass through unchanged. The (?<!\\) lookbehind keeps quoted
// "src: \"...\"" fragments inside string literals (alt text, code blocks)
// from matching.

const TYP_ID = /[/\\]src[/\\]content[/\\](blog|pages)[/\\]([^/\\]+)[/\\]index\.html\.typ(?:\?.*)?$/;
const BARE_IMG_SRC = /(?<!\\)src: "([^"/\\:?*]+)"/g;

export function resolvePostImages() {
  return {
    name: "resolve-post-images",
    enforce: "post",
    transform(code, id) {
      const m = TYP_ID.exec(id);
      if (!m) return;
      const [, kind, slug] = m;
      const resolved = code.replace(
        BARE_IMG_SRC,
        (_m, name) => `src: "/content/${kind}/${slug}/${name}"`,
      );
      if (resolved === code) return;
      return { code: resolved, map: null };
    },
  };
}
