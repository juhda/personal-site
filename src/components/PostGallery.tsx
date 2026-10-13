import type { Post } from '../blog/lib';
import PostCard from './PostCard';

interface Props {
  posts: Post[];
  tagNames: Record<string, string>;
}

export default function PostGallery({ posts, tagNames }: Props) {
  const columns =
    posts.length === 1
      ? 'grid-cols-1'
      : 'md:grid-cols-2';

  return (
  <div class={"grid gap-6 w-full mx-auto items-center " + columns}>
    {posts.map(post => (
      <PostCard post={post} tagNames={tagNames} />
    ))}
  </div>
  );
}
