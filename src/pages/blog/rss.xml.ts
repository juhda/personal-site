import rss from '@astrojs/rss';

import { getPublishedPosts, getTagNames } from '../../blog/lib';
import { blogDescriptionSEO, blogNumRSSPosts, blogTitle } from '../../config/site';

export async function GET() {
  const posts = await getPublishedPosts();
  // RSS pubDate is strictly the publication date; posts without one (e.g.
  // uncommitted drafts in dev/preview) are not syndication-ready.
  const recent = posts
    .filter(post => post.data.publishedAt)
    .slice(0, blogNumRSSPosts);
  const tagNames = await getTagNames();

  const baseUrl = import.meta.env.SITE;
  if (!baseUrl) {
    return new Response('RSS generation failed: site URL is not set in astro.config.mjs.', { status: 500 });
  }

  return rss({
    title: `${blogTitle} RSS Feed`,
    description: blogDescriptionSEO,
    site: baseUrl,
    items: recent.map(post => ({
      title: post.data.title,
      link: `/blog/${post.id}`,
      pubDate: new Date(post.data.publishedAt!),
      description: post.data.description,
      categories: post.data.tags.map(slug => tagNames.get(slug)!)
    })),
    customData: "<language>en</language>"
  });
}
