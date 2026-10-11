import { useState, useEffect } from 'preact/hooks';
import PostGallery from './PostGallery';
import EmptyState from './EmptyState';

import type { Post } from '../blog/lib';

interface Props {
  posts: Post[];
  tagNames: Record<string, string>;
  search_input: string;
}

export default function SearchResults({ posts, tagNames, search_input }: Props) {
  const [query, setQuery] = useState('');

  useEffect(() => {
    const input = document.getElementById(search_input) as HTMLInputElement | null;
    if (!input) return;

    let timeout: number;

    const onInput = () => {
      clearTimeout(timeout);
      timeout = window.setTimeout(() => {
        setQuery(input.value.toLowerCase());
      }, 150); // wait 150ms
    };

    input.addEventListener('input', onInput);

    return () => {
      clearTimeout(timeout);
      input.removeEventListener('input', onInput);
    };
  }, []);

  const normalized = (str: string) => str.toLowerCase();
  const filtered = query
    ? posts.filter(post => {
        const title = normalized(post.data.title);
        const description = normalized(post.data.description);
        const tags = post.data.tags
          .map(slug => normalized(tagNames[slug]))
          .join(' ');
        return title.includes(query) || description.includes(query) || tags.includes(query);
      })
    : [];

  return (
    <div>
      {query && filtered.length > 0 && (
        <PostGallery posts={filtered} tagNames={tagNames} />
      )}

      {query && filtered.length === 0 && (
        <EmptyState
          icon='🔍'
          title="No matching posts"
          message="Try a different keyword or tag."
        />
      )}
    </div>
  );
}
