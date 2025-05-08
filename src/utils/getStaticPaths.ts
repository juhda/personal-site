import { getAllSeriesInfo, getAllTags, getPostSlugs } from "../hashnode-lib/client";

export function pathToFunctionName(path: String) {
  return `getStaticPaths${path.replace(/\//g, '_')}`
}

export async function getStaticPaths_blog() {
  const postSlugs = await getPostSlugs();
  return postSlugs.map(slug => ({
    params: { slug }
  }));
}

export async function getStaticPaths_blog_tags() {
  const tags = await getAllTags();
  return tags.map(tagInfo => ({
    params: { tag: tagInfo.slug }
  }));
}

export async function getStaticPaths_blog_series() {
  const allSeriesInfo = await getAllSeriesInfo();
  return allSeriesInfo.map(seriesInfo => ({
    params: { series_name: seriesInfo.slug }
  }));
}

export default {
  pathToFunctionName,
  getStaticPaths_blog,
  getStaticPaths_blog_tags,
  getStaticPaths_blog_series
};
