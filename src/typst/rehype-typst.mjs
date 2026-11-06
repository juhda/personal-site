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
// 4. Typst's #link emits bare <a href>. External links get target="_blank" +
//    rel="noopener noreferrer" and the Link component's trailing indicator
//    (↗ plus an sr-only announcement), and hrefs matching a configured social
//    link get a GoatCounter click event — mirroring the Link component so
//    Typst-rendered prose behaves like Link-authored markup. (Link's ⬇
//    download variant has no analogue here: Typst content has no downloads.)
// 5. The pages preamble's muted-rule command emits a <muted-rule> marker,
//    since Typst cannot attach classes to elements; it is merged into the
//    next sibling as class "muted-top-rule" and removed.

import { socialLinks, isExternalLink } from "../config/site";

// GoatCounter auto-event names for the configured social links (e.g. an
// href equal to socialLinks.linkedin becomes "linkedin-click").
const SOCIAL_EVENTS = new Map(
  Object.entries(socialLinks).map(([key, href]) => [href, `${key}-click`]),
);

// hast nodes for Link's external-link indicator, appended after the link
// text. ariaHidden/className are the canonical hast property names the
// serializer emits as aria-hidden/class.
const externalLinkIcon = () => [
  {
    type: "element",
    tagName: "span",
    properties: { ariaHidden: "true" },
    children: [{ type: "text", value: "↗" }],
  },
  {
    type: "element",
    tagName: "span",
    properties: { className: ["sr-only"] },
    children: [{ type: "text", value: "External link opens in new tab" }],
  },
];

const MUTED_RULE = "muted-rule";

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
      if (node.tagName === "a") {
        const href = propOf(node, "href");
        if (typeof href === "string") {
          const isExternal = isExternalLink(href);
          const socialEvent = SOCIAL_EVENTS.get(href);
          if (isExternal || socialEvent) {
            node.properties = node.properties ?? {};
            if (isExternal) {
              node.properties.target = "_blank";
              node.properties.rel = "noopener noreferrer";
              node.children = [
                ...(node.children ?? []),
                ...externalLinkIcon(),
              ];
            }
            if (socialEvent) {
              node.properties["data-goatcounter-click"] = socialEvent;
            }
          }
        }
      }
    }
    if (Array.isArray(node.children)) {
      const children = node.children;
      for (let i = 0; i < children.length; i++) {
        const child = children[i];
        if (child?.type === "element" && child.tagName === MUTED_RULE) {
          // Merge the marker into the next element; anything else between
          // them (e.g. whitespace text nodes) is left as is.
          const next = children.slice(i + 1).find((n) => n.type === "element");
          if (next) {
            next.properties = next.properties ?? {};
            const cls = next.properties.className;
            const classes = Array.isArray(cls)
              ? cls
              : cls
                ? String(cls).split(/\s+/)
                : [];
            if (!classes.includes("muted-top-rule")) {
              next.properties.className = [...classes, "muted-top-rule"];
            }
          }
          children.splice(i, 1);
          i--;
          continue;
        }
        walk(child);
      }
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
