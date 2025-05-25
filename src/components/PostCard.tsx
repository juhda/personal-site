import Link from './Link';

import type { PostInfo } from '../hashnode-lib/schema';

interface Props {
  postInfo: PostInfo;
}

export default function PostCard({ postInfo }: Props) {
  return (
    <section class="nested-card">
      <Link href={`/blog/${postInfo.slug}`}>
        {postInfo.bannerImage?.url && (
          <div class="banner-image-container">
            <img
              src={postInfo.bannerImage.url}
              alt={postInfo.title}
            />
          </div>
        )}
        <h3 class="mb-1">{postInfo.title}</h3>

        {postInfo.subtitle && (
          <p class="text-primary italic text-sm mb-2">{postInfo.subtitle}</p>
        )}

        <p class="text-sm mb-2">{postInfo.brief}</p>

      </Link>
      <div class="flex flex-wrap gap-2 text-xs text-accent">
        <time>{new Date(postInfo.publishedAt).toLocaleDateString()}</time>
        {postInfo.tags.map(tag => (
        <Link
          href={`/blog/tags/${tag.slug}`}
          class="bg-surface px-2 rounded text-accent border border-accent/30 hover:bg-surface/70 transition inline-block max-w-full truncate"
        >
          #{tag.name}
        </Link>
        ))}
      </div>
    </section>
  );
}
