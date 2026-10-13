// Pure URL helpers for colocated content images. Importable from client-side
// components (no astro:content dependency).
//
// Posts list bare image filenames in meta.yaml / .typ; the site resolves them
// to the served location. Post images are organized in an images/ subdirectory
// in the source but served flat next to the post, like series covers:
//   src/content/blog/<slug>/images/<name>   -> /content/blog/<slug>/<name>
//   src/content/series/<slug>/<name>        -> /content/series/<slug>/<name>

import type { Post, Series } from "./lib";

export function postImageUrl(post: Pick<Post, "id">, name: string): string {
  return `/content/blog/${post.id}/${name}`;
}

export function postCoverUrl(post: Post): string | null {
  return post.data.coverImage ? postImageUrl(post, post.data.coverImage) : null;
}

export function postOgUrl(post: Post): string | null {
  return post.data.ogImage ? postImageUrl(post, post.data.ogImage) : null;
}

export function seriesCoverUrl(series: Series): string | null {
  return series.data.coverImage
    ? `/content/series/${series.id}/${series.data.coverImage}`
    : null;
}
