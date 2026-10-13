import Link from './Link';

import type { Post } from '../blog/lib';
import { postCoverUrl } from '../blog/urls';

interface Props {
  post: Post;
  tagNames: Record<string, string>;
}

export default function PostCard({ post, tagNames }: Props) {
  const { data } = post;
  const isDraft = data.draft;
  const linkPath = isDraft ? `/blog/drafts/${post.id}` : `/blog/${post.id}`;
  const coverImageURL = postCoverUrl(post);
  const titleString = data.title || 'Untitled';
  const dateToShow = isDraft ? data.updatedAt : (data.publishedAt ?? data.updatedAt);
  const dateString = dateToShow ? new Date(dateToShow).toLocaleDateString() : '';

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

        {data.subtitle && (
          <p class="text-primary italic text-sm mb-2">{data.subtitle}</p>
        )}

        {data.description && (
          <p class="text-sm mb-2">{data.description}</p>
        )}

      </Link>
      <div class="flex flex-wrap gap-2 text-xs text-accent">
        {dateString && <time>{dateString}</time>}
        {data.tags.map(slug => (
        <Link
          href={`/blog/tags/${slug}`}
          class="bg-surface px-2 rounded text-accent border border-accent/30 hover:bg-surface/70 transition inline-block max-w-full truncate"
        >
          #{tagNames[slug]}
        </Link>
        ))}
      </div>
    </section>
  );
}
