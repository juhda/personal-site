import type { PostInfo } from '../hashnode-lib/schema';
import PostCard from './PostCard';

interface Props {
  allPostInfo: PostInfo[]
}

export default function PostGallery({ allPostInfo }: Props) {
  const columns =
    allPostInfo.length === 1
      ? 'grid-cols-1'
      : 'md:grid-cols-2';

  return (
  <div class={"grid gap-6 w-full mx-auto items-center " + columns}>
    {allPostInfo.map(postInfo => (
      <PostCard postInfo={postInfo} />
    ))}
  </div>
  );
}
