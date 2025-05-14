import generateRSS from '@astrojs/rss';
import { getBlogInfo, getRecentPostInfo } from '../../hashnode-lib/client';
import { blogNumRSSPosts } from '../../config/site';

export const prerender = false;

export async function GET() {
  const blogInfo = await getBlogInfo();
  const posts = await getRecentPostInfo(blogNumRSSPosts);

  const baseUrl = import.meta.env.SITE;
  if (!baseUrl) {
    return new Response('RSS generation failed: site URL is not set in astro.config.mjs.', { status: 500 });
  }

  return generateRSS({
    title: `${blogInfo.title} RSS Feed`,
    description: blogInfo.about.text.trim(),
    site: baseUrl,
    items: posts.map(post => ({
      title: post.title,
      link: `/blog/${post.slug}`,
      pubDate: new Date(post.publishedAt),
      description: post.brief,
      categories: post.tags?.map(tag => tag.name)
    })),
    customData: "<language>en</language>"
  });
}
