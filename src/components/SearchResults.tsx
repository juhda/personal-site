import { useState, useEffect } from 'preact/hooks';
import PostGallery from './PostGallery';
import EmptyState from './EmptyState';

import type { PostInfo } from '../hashnode-lib/schema';

interface Props {
  posts: PostInfo[];
  search_input: string;
}

export default function SearchResults({ posts, search_input }: Props) {
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
        const title = normalized(post.title);
        const brief = normalized(post.brief ?? '');
        const tags = post.tags.map(t => normalized(t.name)).join(' ');
        return title.includes(query) || brief.includes(query) || tags.includes(query);
      })
    : [];

  useEffect(() => {
    if (typeof window.MathJax !== 'undefined') {
      window.MathJax.typeset();
    }
  }, [filtered]);

  return (
    <div>
      {query && filtered.length > 0 && (
        <PostGallery allPostInfo={filtered} />
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
