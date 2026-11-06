// Shared rendering definitions for all Typst content: blog post bodies
// (src/content/blog/<slug>/index.html.typ) and static page bodies
// (src/content/pages/<slug>/*.html.typ). Definitions that only make sense
// for one kind of content live in that kind's own preamble instead
// (src/content/blog/_preamble.typ, src/content/pages/_preamble.typ), and
// single-file definitions live in the using file.
//
// Content files bind what they need with:
//
//   #let (callout, horizontalrule)
//     = eval(read("<path>/_preamble.typ"), mode: "code")
//
// (two levels up from content files: ../../_preamble.typ for this shared
// file, ../_preamble.typ for the kind-specific files). A single-name
// binding needs a trailing comma to form a destructuring pattern:
//
//   #let (blog-img,) = eval(read("../_preamble.typ"), mode: "code")
//
// Identity constants (author, jobTitle, cleanJobTitle) and social links
// (social-email, social-linkedin, social-github, one social-<name> per
// entry in site.ts) come from the generated module (src/generated/site.typ,
// refresh with `npm run generate:typst-config`); bind them separately
// (same tuple pattern; a single name needs the trailing comma):
//
//   #let (author, jobTitle, cleanJobTitle)
//     = eval(read("../../../generated/site.typ"), mode: "code")
//
// read+eval is used instead of #import on purpose. An import evaluates this
// file as its own module, so file paths written here would resolve relative
// to this file's directory. eval() instead synthesizes the spans of the
// evaluated code at the call site, so helpers that reference files resolve
// paths relative to the *calling* file's directory. (Only the blog preamble
// relies on this today; the file-based recipes here still use read+eval for
// uniformity.)
//
// This file is written in code mode (no leading `#`): eval(..., mode: "code")
// evaluates it as a code block and this file's final expression, the
// dictionary below, becomes the destructured bindings in the caller.

// Typst's `html` module (html.elem) only exists in HTML export mode. These
// bodies target the site's HTML pipeline, but any compile not targeting HTML
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

// callout: a callout box for warnings, notes, and asides.
// Both modes: a block quote (renders <blockquote>). quote() defaults to an
// inline quote (curly-quoted <q> inside a paragraph), so block: true is
// load-bearing; this alias keeps sources short.
let callout = (body) => quote(block: true, body)

(
  horizontalrule: horizontalrule,
  callout: callout,
)
