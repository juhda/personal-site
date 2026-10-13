// Post-processing for Typst HTML export (hAST), injected into astro-typst's
// compile pipeline via the typstBridged wrapper in astro.config.mjs. The
// site has no markdown content, so these plugins only affect astro-typst
// output.
//
// Note: typstx's pipeline hands this transformer the <body> element (not the
// hast root) as the tree.
//
// Rewrites:
// 1. Rename typst's <body> wrapper to a plain <div> (keeps article-scoped CSS
//    working; visually neutral).
// 2. pre > code[data-lang] -> add class "language-<lang>" (CodeblockEnhancer +
//    article pre/code CSS parity with Hashnode markup).
// 3. Highlighted token spans carry inline style="color:#XXXXXX" -> convert to
//    class "tk-XXXXXX" so light/dark palettes can be defined in CSS instead of
//    hard-coded inline colors.

export function rehypeTypstHtml() {
  const propOf = (node, name) => {
    const p = node.properties ?? {};
    return p[name] ?? p[name.toLowerCase()] ?? p["data-lang"];
  };

  const setClass = (node, classes) => {
    node.properties = node.properties ?? {};
    node.properties.className = classes;
  };

  const walk = (node) => {
    if (!node || typeof node !== "object") return;
    if (node.type === "element") {
      if (node.tagName === "code" && propOf(node, "dataLang")) {
        const lang = String(propOf(node, "dataLang"));
        const existing = Array.isArray(node.properties?.className)
          ? node.properties.className
          : [];
        setClass(node, [...existing, `language-${lang}`]);
      }
      if (node.tagName === "span" && typeof propOf(node, "style") === "string") {
        const m = propOf(node, "style").match(/color:\s*(#[0-9a-fA-F]{6})/);
        if (m) {
          setClass(node, [`tk-${m[1].slice(1).toLowerCase()}`]);
          delete node.properties.style;
        }
      }
    }
    if (Array.isArray(node.children)) {
      for (const child of node.children) walk(child);
    }
  };

  return (tree) => {
    if (tree?.type === "element" && tree.tagName === "body") {
      tree.tagName = "div";
      tree.properties = {};
    }
    walk(tree);
    return tree;
  };
}
