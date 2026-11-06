// Shared rendering definitions for static page bodies
// (src/content/pages/<slug>/*.html.typ). Generic prose helpers live in the
// common ancestor preamble (src/content/_preamble.typ); only definitions
// that make sense exclusively for page bodies belong here; definitions
// needed by a single page are defined in that page's own body file. Page
// titles are hardcoded in the wrapping .astro files, not authored here.

// anchor: attach a fragment-link id (e.g. /portfolio#compilers-...) to the
// next heading:
//
//   #anchor("compilers-and-instruction-set-architectures")
//   = Compilers and Instruction Set Architectures
//
// Typst's own heading HTML export emits no ids, and Typst cannot attach
// attributes to its own elements, so this emits a marker element that the
// rehype post-processing (rewrites 5-6 in rehype-typst.mjs) merges into
// the following heading. Any other element after the marker fails the
// build.
// Paged preview: no analogue — ids only exist in HTML; nothing is emitted.
let anchor = (id) => context if target() == "html" {
  html.elem("anchor", attrs: ("id": id))
} else {
  none
}

// muted-rule: the muted-top-rule separation from global.css, attached to the
// next block (heading, paragraph, ...) in the source:
//
//   #muted-rule
//   = Research and Earlier Work
//
// Typst cannot express per-element HTML classes, so this emits a marker
// element that the rehype post-processing (rewrites 5-6 in rehype-typst.mjs)
// merges into the following element as class "muted-top-rule" before the
// site ever sees it.
// Paged preview: a full-width hairline.
let muted-rule = context if target() == "html" {
  html.elem("muted-rule")
} else {
  line(length: 100%, stroke: 0.5pt)
}

(
  anchor: anchor,
  muted-rule: muted-rule,
)
