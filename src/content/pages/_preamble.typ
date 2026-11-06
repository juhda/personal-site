// Shared rendering definitions for static page bodies
// (src/content/pages/<slug>/*.html.typ). Generic prose helpers live in the
// common ancestor preamble (src/content/_preamble.typ); only definitions
// that make sense exclusively for page bodies belong here; definitions
// needed by a single page are defined in that page's own body file.

// page-title: the main title of a static page. Typst's heading export maps
// `=` (level 1) to <h2> — the body hierarchy starts one level below the
// page title — so the <h1> needs an explicit element.
// HTML export: an <h1>.
// Paged preview: a native level-1 heading.
let page-title = (body) => context if target() == "html" {
  html.elem("h1", body)
} else {
  heading(level: 1, body)
}

// nowrap: a non-breaking inline span (e.g. the job title in the About
// prose).
// HTML export: a <span class="whitespace-nowrap">.
// Paged preview: the body in a box, whose contents do not break across lines.
let nowrap = (body) => context if target() == "html" {
  html.elem("span", attrs: ("class": "whitespace-nowrap"), body)
} else {
  box(body)
}

// anchor-h2: a section heading carrying a fragment-link id (e.g.
// /portfolio#compilers-and-instruction-set-architectures) that other pages
// cross-reference. Typst's own heading HTML export emits no ids.
// HTML export: an <h2> with the id attribute.
// Paged preview: a native level-2 heading (ids have no paged analogue).
let anchor-h2 = (id, body) => context if target() == "html" {
  html.elem("h2", attrs: ("id": id), body)
} else {
  heading(level: 2, body)
}

// muted-rule: the muted-top-rule separation from global.css, attached to the
// next block (heading, paragraph, ...) in the source:
//
//   #muted-rule
//   = Research and Earlier Work
//
// Typst cannot express per-element HTML classes, so this emits a marker
// element that the rehype post-processing (rewrite 5 in rehype-typst.mjs)
// merges into the following element as class "muted-top-rule" before the
// site ever sees it.
// Paged preview: a full-width hairline.
let muted-rule = context if target() == "html" {
  html.elem("muted-rule")
} else {
  line(length: 100%, stroke: 0.5pt)
}

(
  page-title: page-title,
  nowrap: nowrap,
  anchor-h2: anchor-h2,
  muted-rule: muted-rule,
)
