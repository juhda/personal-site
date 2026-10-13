import { getCollection, getEntry, type CollectionEntry } from "astro:content";
import type { ComponentType } from "astro";

import { blogSearchLimit } from "../config/site";

export type Post = CollectionEntry<"blog">;
export type Series = CollectionEntry<"series">;

export interface TagInfo {
  slug: string;
  name: string;
  count: number;
}

// Typst post bodies, compiled by astro-typst to components at build time.
const typstModules = import.meta.glob<{ default: ComponentType }>(
  "/src/content/blog/*/index.html.typ",
);

/** Drafts are visible in `astro dev` and in Netlify branch deploy previews. */
export const draftContext =
  import.meta.env.DEV ||
  (typeof process !== "undefined" &&
    Boolean(process.env.CONTEXT) &&
    process.env.CONTEXT !== "production");

function dateOf(entry: Post): number {
  const d = entry.data.publishedAt ?? entry.data.updatedAt;
  return d ? new Date(d).getTime() : 0;
}

function byPublishedDesc(a: Post, b: Post): number {
  return dateOf(b) - dateOf(a);
}

/** All published (non-draft) posts, newest first. Drafts never appear on
 * published surfaces — they are previewed via getDraftPosts at
 * /blog/drafts/<id>. */
export async function getPublishedPosts(): Promise<Post[]> {
  const posts = await getCollection("blog", p => !p.data.draft);
  return posts.sort(byPublishedDesc);
}

/** Draft posts (dev / branch previews only; empty in production builds). */
export async function getDraftPosts(): Promise<Post[]> {
  if (!draftContext) return [];
  const posts = await getCollection("blog", p => p.data.draft);
  return posts.sort(byPublishedDesc);
}

export async function getPost(slug: string): Promise<Post | undefined> {
  return getEntry("blog", slug);
}

/** Posts of a series in publication (reading) order: oldest first. */
export async function getSeriesPosts(seriesSlug: string): Promise<Post[]> {
  const posts = await getPublishedPosts();
  return posts.filter(p => p.data.series === seriesSlug).reverse();
}

export async function getSeriesBySlug(slug: string): Promise<Series | undefined> {
  return getEntry("series", slug);
}

/** All defined series. A series is listed (and gets a detail page) simply
 * by being defined in src/content/series/<slug>/meta.yaml — regardless of
 * whether it has published posts yet. */
export async function getSeries(): Promise<Series[]> {
  return getCollection("series");
}

/** Tag display names (slug -> name). Explicit names live in
 * src/content/tags.yaml. A post tag without an entry there fails the build;
 * the map is complete by construction, so lookups cannot miss. */
export async function getTagNames(): Promise<Map<string, string>> {
  const [tags, posts] = await Promise.all([
    getCollection("tags"),
    getCollection("blog"),
  ]);
  const names = new Map(tags.map(t => [t.id, t.data.name]));
  const missing = new Set<string>();
  for (const post of posts) {
    for (const slug of post.data.tags) {
      if (!names.has(slug)) {
        missing.add(slug);
        names.set(slug, slug);
      }
    }
  }
  if (missing.size > 0) {
    throw new Error(
      `Tags without a display name definition in src/content/tags.yaml: ${[...missing].sort().join(", ")}`,
    );
  }
  return names;
}

/** Plain-object variant for passing into Preact components. */
export async function getTagNameMap(): Promise<Record<string, string>> {
  return Object.fromEntries(await getTagNames());
}

/** Tag list with post counts, most used first. */
export async function getTags(): Promise<TagInfo[]> {
  const posts = await getPublishedPosts();
  const names = await getTagNames();
  const map = new Map<string, TagInfo>();
  for (const post of posts) {
    for (const slug of post.data.tags) {
      const existing = map.get(slug);
      if (existing) {
        existing.count += 1;
      } else {
        map.set(slug, { slug, name: names.get(slug)!, count: 1 });
      }
    }
  }
  return Array.from(map.values()).sort((a, b) => b.count - a.count);
}

export async function getTaggedPosts(tagSlug: string): Promise<Post[]> {
  const posts = await getPublishedPosts();
  return posts.filter(p => p.data.tags.includes(tagSlug));
}

/** The body component of a post, compiled from index.html.typ. The body is a
 * sibling of meta.yaml, so entry.render() (single-file entries) cannot supply
 * it; the glob bridges post ids to their compiled components. */
export async function getPostBody(slug: string): Promise<ComponentType | undefined> {
  const loader = typstModules[`/src/content/blog/${slug}/index.html.typ`];
  if (!loader) return undefined;
  const mod = await loader();
  return mod.default;
}

/** Number of published posts; used for the search feature gate. */
export async function getSearchEnabled(): Promise<boolean> {
  const posts = await getPublishedPosts();
  return posts.length >= blogSearchLimit;
}
