// Shared rendering definitions for blog post bodies
// (src/content/blog/<slug>/index.html.typ). Generic prose helpers used by
// posts live in the common ancestor preamble (src/content/_preamble.typ);
// only definitions that make sense exclusively for blog posts belong here.

// blog-img: an inline image; `src` is the bare filename of a file in the
// post's images/ subdirectory, `alt` its alternative text.
// HTML export: a plain <img> with the site-relative URL — deliberately not
// Typst's image(), which would inline the file as base64 and validate the
// path against the workspace at compile time, which the served site cannot
// use.
// Paged preview: read+eval synthesizes this code's spans at the calling
// post, so the image path resolves relative to the *calling* post's
// directory — this embeds each post's own images/ files. Local files are
// embedded with the alt text repeated as a small centered caption below for
// editorial review; empty alt shows no caption. image() cannot fetch remote
// URLs, so http(s) sources keep a placeholder box showing the alt text.
let blog-img = (src, alt: "") => context if target() == "html" {
  html.elem("img", attrs: ("src": src, "alt": alt))
} else if src.starts-with("http://") or src.starts-with("https://") {
  rect(width: 100%, height: 4em, inset: 8pt, radius: 4pt)[
    #align(center)[#alt]
  ]
} else {
  image("images/" + src, alt: alt) + if alt != "" {
    v(2pt) + align(center, text(size: 7pt, fill: luma(120))[#alt])
  }
}

(
  blog-img: blog-img,
)
