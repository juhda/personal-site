import { defineCollection, z } from "astro:content";
import { file, glob, type Loader } from "astro/loaders";
import type { LoaderContext } from "astro/loaders";

import { firstCommitDate, lastCommitDate } from "./blog/git-dates";

/**
 * Blog loader: the standard glob loader over meta.yaml, plus git-derived
 * dates for posts that don't set them explicitly in meta.yaml.
 *   publishedAt <- first commit adding the post directory
 *   updatedAt   <- last commit touching the post directory
 * Explicit meta.yaml values always win. Requires git history at build time;
 * uncommitted posts (e.g. new drafts in dev) have no dates until committed.
 */
function blogLoader(options: { pattern: string; base: string; generateId: (opts: any) => string }): Loader {
  const inner = glob(options);
  return {
    name: "blog-loader",
    async load(context: LoaderContext) {
      await inner.load(context);
      for (const [id, entry] of context.store.entries()) {
        const data = entry.data as Record<string, unknown>;
        if (data.publishedAt != null && data.updatedAt != null) continue;
        const filePath: string = entry.filePath;
        const postDir = filePath.slice(0, filePath.lastIndexOf("/"));
        const patch: Record<string, string> = {};
        if (data.publishedAt == null) {
          const d = firstCommitDate(postDir);
          if (d) patch.publishedAt = d;
        }
        if (data.updatedAt == null) {
          const d = lastCommitDate(postDir);
          if (d) patch.updatedAt = d;
        }
        if (Object.keys(patch).length === 0) continue;
        context.store.set({
          id,
          data: { ...data, ...patch },
          filePath: entry.filePath,
          digest: entry.digest,
          assetImports: entry.assetImports,
          deferredRender: entry.deferredRender,
        });
      }
    },
  };
}

/**
 * Blog posts: metadata in meta.yaml (body is index.html.typ, rendered via
 * astro-typst and loaded with import.meta.glob in the page).
 * Entry id = the post's directory name = its URL slug.
 */
const blog = defineCollection({
  loader: blogLoader({
    pattern: "*/meta.yaml",
    base: "./src/content/blog",
    generateId: ({ entry }) => entry.split("/")[0],
  }),
  schema: z.object({
    title: z.string(),
    subtitle: z.string().nullable().optional(),
    // Short summary: SEO description, card text, and RSS description.
    description: z.string(),
    // Optional SEO title override; falls back to title.
    seoTitle: z.string().nullable().optional(),
    // Dates: optional here — explicit meta.yaml values win; otherwise the
    // loader fills them from git history (see blogLoader above).
    publishedAt: z.string().optional(),
    updatedAt: z.string().optional(),
    // Tag slugs; display names map once in src/content/tags.yaml. Every
    // slug used here needs an entry there — the build warns otherwise.
    tags: z.array(z.string()),
    // Series membership; null (or omitted) means a standalone post.
    series: z.string().nullable().default(null),
    // Colocated images, referenced by bare filename (resolved to
    // /content/blog/<slug>/<name> at render). Default to the
    // conventional names; explicit null means "no image".
    coverImage: z.string().nullable().default("cover.png"),
    ogImage: z.string().nullable().default("og.png"),
    draft: z.boolean().default(false),
  }),
});

/** Series: metadata + colocated cover per subdirectory; member posts
 * reference a series via meta.yaml `series`. */
const series = defineCollection({
  loader: glob({
    pattern: "*/meta.yaml",
    base: "./src/content/series",
    generateId: ({ entry }) => entry.split("/")[0],
  }),
  schema: z.object({
    name: z.string(),
    description: z.string().nullable().optional(),
    coverImage: z.string().nullable().default("cover.png"),
  }),
});

/** Tags: display-name mapping list (src/content/tags.yaml). Entries are
 * keyed by their `slug` field. Every tag a post lists in meta.yaml must have
 * an entry here — the build fails on tags missing a name definition
 * (see getTagNames in src/blog/lib.ts). */
const tagSlugSchema = z
  .string()
  .regex(
    /^[a-z]+(?:-[a-z]+)*$/,
    'Tag slugs must be lowercase letters joined by single dashes, e.g. "ai-reasoning".',
  );

const tags = defineCollection({
  loader: file("./src/content/tags.yaml"),
  schema: z.object({
    slug: tagSlugSchema,
    name: z.string(),
  }),
});

export const collections = { blog, series, tags };
