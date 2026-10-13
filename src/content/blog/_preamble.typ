// Shared rendering definitions for blog posts. Each post starts with:
//
//   #import "../_preamble.typ": blog-img, horizontalrule
//
// The helpers are used inline in the body.

// A markdown-style thematic break (---) has no Typst equivalent: `---` is
// an em-dash, and drawn lines produce no HTML output. Rendering a real <hr>
// (for the `article hr` CSS) therefore requires this definition.
#let horizontalrule = html.elem("hr")

// Emit a plain HTML <img> with a site-relative URL. Typst's image() would
// inline the file as base64 and validate the path against the workspace at
// compile time.
#let blog-img(src, alt: "") = html.elem("img", attrs: ("src": src, "alt": alt))

// Callout box: a block quote (renders <blockquote>). quote() defaults to an
// inline quote (curly-quoted <q> inside a paragraph), so block: true is
// load-bearing; this alias keeps post sources short.
#let callout(body) = quote(block: true, body)
