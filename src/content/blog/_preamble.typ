// Shared rendering definitions for blog posts. Each post starts with:
//
//   #let (blog-img, callout, horizontalrule) =
//     eval(read("../_preamble.typ"), mode: "code")
//
// read+eval is used instead of #import on purpose. An import evaluates this
// file as its own module, so image paths written here would resolve relative
// to this file's directory (src/content/blog/). eval() instead synthesizes
// the spans of the evaluated code at the call site, so the helpers below
// resolve file paths relative to the *calling* post's directory. That is
// what lets the paged preview embed images/<name> from the post's own
// images/ subdirectory.
//
// This file is written in code mode (no leading `#`): eval(..., mode: "code")
// evaluates it as a code block and this file's final expression, the
// dictionary below, becomes the destructured bindings in the post.

// Typst's `html` module (html.elem) only exists in HTML export mode. These
// posts target the site's HTML pipeline, but any compile not targeting HTML
// output (e.g. an editor's paged preview) would fail on the bare `html`
// references. The contextual target() function reports the current export
// mode ("html" or "paged"), so each helper emits real HTML elements when
// exporting to HTML and a native paged equivalent otherwise. Each branch is
// only ever evaluated in its own mode, so no mode ever sees an unknown name.

// horizontalrule: a markdown-style thematic break (---), which has no Typst
// equivalent.
// HTML export: a real <hr>, so the `article hr` CSS applies.
// Paged preview: a full-width hairline.
let horizontalrule = context if target() == "html" {
  html.elem("hr")
} else {
  line(length: 100%, stroke: 0.5pt)
}

// blog-img: an inline image; `src` is the bare filename of a file in the
// post's images/ subdirectory, `alt` its alternative text.
// HTML export: a plain <img> with the site-relative URL — deliberately not
// Typst's image(), which would inline the file as base64 and validate the
// path against the workspace at compile time, which the served site cannot
// use.
// Paged preview: local files are embedded (paths resolve relative to the
// calling post, see the header comment) with the alt text repeated as a
// small centered caption below for editorial review; empty alt shows no
// caption. image() cannot fetch remote URLs, so http(s) sources keep a
// placeholder box showing the alt text.
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

// callout: a callout box for warnings, notes, and asides.
// Both modes: a block quote (renders <blockquote>). quote() defaults to an
// inline quote (curly-quoted <q> inside a paragraph), so block: true is
// load-bearing; this alias keeps post sources short.
let callout = (body) => quote(block: true, body)

(
  horizontalrule: horizontalrule,
  blog-img: blog-img,
  callout: callout,
)
