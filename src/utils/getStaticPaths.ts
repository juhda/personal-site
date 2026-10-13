import { getPublishedPosts, getDraftPosts, getTags, getSeries } from "../blog/lib";

export function pathToFunctionName(path: String) {
  return `getStaticPaths${path.replace(/\//g, '_')}`
}

export async function getStaticPaths_blog() {
  const posts = await getPublishedPosts();
  return posts.map(post => ({
    params: { slug: post.id },
  }));
}

export async function getStaticPaths_blog_tags() {
  const tags = await getTags();
  return tags.map(tagInfo => ({
    params: { tag: tagInfo.slug },
  }));
}

export async function getStaticPaths_blog_series() {
  const seriesList = await getSeries();
  return seriesList.map(s => ({
    params: { series_name: s.id },
  }));
}

export async function getStaticPaths_blog_drafts() {
  const drafts = await getDraftPosts();
  return drafts.map(draft => ({
    params: { slug: draft.id },
  }));
}

export default {
  pathToFunctionName,
  getStaticPaths_blog,
  getStaticPaths_blog_tags,
  getStaticPaths_blog_series,
  getStaticPaths_blog_drafts
};
