import Link from './Link';

import type { PostInfo, DraftInfo } from '../hashnode-lib/schema';

interface Props {
  postInfo: PostInfo | DraftInfo;
}

export default function PostCard({ postInfo }: Props) {
  const isDraft = 'id' in postInfo && !('slug' in postInfo);
  const linkPath = isDraft ? `/blog/drafts/${postInfo.id}` : `/blog/${postInfo.slug}`;
  const coverImageURL = postInfo.coverImage?.url || null;
  const titleString = postInfo.title || 'Untitled';
  const dateToShow = 'publishedAt' in postInfo ? postInfo.publishedAt : postInfo.updatedAt;
  const dateString = new Date(dateToShow).toLocaleDateString();

  return (
    <section class="nested-card">
      <Link href={linkPath}>
        {coverImageURL && (
          <div class="cover-image-container">
            <img
              src={coverImageURL}
              alt={titleString}
            />
          </div>
        )}
        <h3 class="mb-1">{titleString}</h3>

        {postInfo.subtitle && (
          <p class="text-primary italic text-sm mb-2">{postInfo.subtitle}</p>
        )}

        {"brief" in postInfo && (
          <p class="text-sm mb-2">{postInfo.brief}</p>
        )}

      </Link>
      <div class="flex flex-wrap gap-2 text-xs text-accent">
        <time>{dateString}</time>
        {'tags' in postInfo && postInfo.tags.map(tag => (
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
