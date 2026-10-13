// Post-transform for astro-typst compiled post modules. Posts reference
// inline images by bare filename (#blog-img("Foo.png") in index.html.typ);
// the site expands them to the served URL (post images are organized in an
// images/ subdirectory in the source but served flat next to the post):
//   src/content/blog/<slug>/images/<name>  ->  /content/blog/<slug>/<name>
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

const POST_TYP_ID = /[/\\]src[/\\]content[/\\]blog[/\\]([^/\\]+)[/\\]index\.html\.typ(?:\?.*)?$/;
const BARE_IMG_SRC = /(?<!\\)src: "([^"/\\:?*]+)"/g;

export function resolvePostImages() {
  return {
    name: "resolve-post-images",
    enforce: "post",
    transform(code, id) {
      const m = POST_TYP_ID.exec(id);
      if (!m) return;
      const slug = m[1];
      const resolved = code.replace(
        BARE_IMG_SRC,
        (_m, name) => `src: "/content/blog/${slug}/${name}"`,
      );
      if (resolved === code) return;
      return { code: resolved, map: null };
    },
  };
}
