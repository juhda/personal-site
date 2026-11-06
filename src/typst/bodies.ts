import type { ComponentType } from "astro";

// Loading of Typst-compiled body components, shared by blog posts and
// static pages. Content files live under src/content/<kind>/<slug>/ and
// are compiled by astro-typst to components at build time:
//   blog:  src/content/blog/<slug>/index.html.typ   (single full body)
//   pages: src/content/pages/<slug>/<name>.html.typ (index + optional named
//          parts, for pages whose layout splits the body around structural
//          elements such as buttons)
const typstBlogModules = import.meta.glob<{ default: ComponentType }>(
  "/src/content/blog/*/index.html.typ",
);

const typstPageModules = import.meta.glob<{ default: ComponentType }>(
  "/src/content/pages/*/*.html.typ",
);

/** The body component compiled from a Typst source under
 * src/content/<kind>/<slug>/. For blogs, the file is fixed
 * (index.html.typ); for pages, <name>.html.typ with a default of
 * index.html. Body files are siblings of meta.yaml, so
 * entry.render() (single-file entries) cannot supply them; the globs
 * bridge content ids to their compiled components. */
export async function getTypstBody(
  kind: "blog" | "pages",
  slug: string,
  name = "index",
): Promise<ComponentType | undefined> {
  const glob = kind === "blog" ? typstBlogModules : typstPageModules;
  const file = kind === "blog" ? "index.html.typ" : `${name}.html.typ`;
  const loader = glob[`/src/content/${kind}/${slug}/${file}`];
  if (!loader) return undefined;
  const mod = await loader();
  return mod.default;
}

/** A blog post's full body, compiled from its index.html.typ. */
export async function getPostBody(slug: string): Promise<ComponentType | undefined> {
  return getTypstBody("blog", slug);
}

/** A static page body or body part, compiled from the sibling
 * <name>.html.typ (default: index.html) in src/content/pages/<slug>/.
 * Undefined for pages whose content has not been migrated to Typst. */
export async function getPageBody(
  slug: string,
  name = "index",
): Promise<ComponentType | undefined> {
  return getTypstBody("pages", slug, name);
}
