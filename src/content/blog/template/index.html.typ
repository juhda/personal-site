// Template post body. The preamble import is required.
#import "../_preamble.typ": blog-img, callout, horizontalrule

#strong[Lead paragraph:] the opener shown before the fold. Use #emph[emphasis] sparingly,
#link("https://davidjuhasz.dev/blog")[links] where they add value, an em-dash like
this --- on both sides spaced, and put a #strong[key idea] in bold.

= First Section

Body text. The `=` heading emits an `h2` (the compiler demotes one level).

- Bullet points work as expected.
- #strong[Nested markup in list items] too.

  ```python
  # Fenced code blocks are highlighted by Typst at build time.
  def hello(name: str) -> str:
      return f"Hello, {name}!"
  ```

= Second Section

// Callout boxes are block quotes; write them with the preamble's callout
// helper (#quote(block: true) renders the same, callout is just shorter):
#callout[
  A callout box for warnings, notes, and asides.
]

// Inline images are colocated in this directory under images/ and referenced
// by bare filename (the site expands them to /content/blog/<slug>/<file>):
//   #blog-img("example.png", alt: "Description of the image.")
// A thematic break renders a real <hr> via the preamble helper:
#horizontalrule

// Math: Typst's HTML export currently drops formula CONTENT silently
// (experimental feature as of Typst 0.14.2) — the equations below will not
// appear in the rendered post until upstream support lands. Equation labels
// and @references DO render (as an anchor and a "Equation 1" link), so
// cross-references keep working. Write it anyway; the formulas will start
// appearing when the compiler supports it.
//
// Inline math: no spaces just inside the dollar signs:
Pythagoras says $a^2 + b^2 = c^2$.

// Block math (formula on its own line): spaces just inside the dollar signs:
$ integral_0^1 x dif x = 1/2 $

// Numbered equations: enable numbering (block equations only) with a set
// rule and label the equation to reference it elsewhere as @euler:
#set math.equation(numbering: "(1)")
$ e^{i pi} + 1 = 0 $ <euler>

As @euler shows, display math can be numbered and referenced.

That's the whole template. Delete this file's contents and write the post.
