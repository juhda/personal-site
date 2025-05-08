import { gql, GraphQLClient } from "graphql-request";
import { blogInfoFragment, postSlugFragment, postTagInfoFragment, postInfoFragment, pageInfoFragment, postFragment, seriesInfoFragment, seriesInitFragment, seriesContFragment } from "./schema";
import type { BlogInfo, BlogInfoQuery, TagCountInfo, PostTagsQuery, PostInfo, PostInfoQuery, PinnedPostInfoQuery, PostSlugsQuery, PageInfo, Post, PostQuery, SeriesInfo, SeriesInfoQuery, Series, SeriesInitQuery, SeriesContQuery } from "./schema";
import { blogHashnodeUrl, blogHashnodeMaxPosts, blogHashnodeMaxSeries, blogSearchLimit } from "../config/site";

// NOTE: Hashnode GraphQL Caching: See NOTE in schema.ts about the id fields.

export const getClient = () => {
  return new GraphQLClient("https://gql.hashnode.com")
}

export const getBlogInfo = async (): Promise<BlogInfo> => {
  const client = getClient();

  const blogInfo = await client.request<BlogInfoQuery>(
    gql`
      ${blogInfoFragment}
      query blogInfo {
        publication(host: "${blogHashnodeUrl}") {
          ...BlogInfoFields
        }
      }
    `
  );

  return blogInfo.publication;
};

export const getPinnedPostInfo = async (): Promise<PostInfo | null> => {
  const client = getClient();

  const pinnedPostInfo = await client.request<PinnedPostInfoQuery>(
    gql`
      ${postInfoFragment}
      query pinnedPost {
        publication(host: "${blogHashnodeUrl}") {
          id
          pinnedPost {
            ...PostInfoFields
          }
        }
      }
    `
  );

  return pinnedPostInfo.publication.pinnedPost;
};

export const getRecentPostInfo = async (n: number): Promise<PostInfo[]> => {
  const client = getClient();

  const recentPostInfo = await client.request<PostInfoQuery>(
    gql`
      ${pageInfoFragment}
      ${postInfoFragment}
      query recentPosts($n: Int!) {
        publication(host: "${blogHashnodeUrl}") {
          id
          posts(first: $n) {
            pageInfo{
              ...PageInfoFields
            }
            edges {
              node {
                ...PostInfoFields
              }
            }
          }
        }
      }
    `,
    { n: n }
  );

  return recentPostInfo.publication?.posts?.edges.map((edge) => edge.node);
};

export const getAllPostInfo = async (): Promise<PostInfo[]> => {
  const client = getClient();

  const allInfo: PostInfo[] = [];
  let hasNextPage = true;
  let after: string | null = null;

  const query = gql`
    ${pageInfoFragment}
    ${postInfoFragment}
    query allPostInfo($after: String) {
      publication(host: "${blogHashnodeUrl}") {
        id
        posts(first: ${blogHashnodeMaxPosts}, after: $after) {
          pageInfo {
            ...PageInfoFields
          }
          edges {
            node {
              ...PostInfoFields
            }
          }
        }
      }
    }
  `;

  while (hasNextPage) {
    const data: PostInfoQuery = await client.request<PostInfoQuery>(query, { after: after });

    const postsData = data.publication?.posts;
    if (!postsData || !postsData.edges) {
      break; // no posts found — exit cleanly
    }

    const edges = postsData.edges;
    const pageInfo: PageInfo = data.publication.posts.pageInfo;

    allInfo.push(...edges.map(edge => edge.node));

    hasNextPage = pageInfo.hasNextPage;
    after = pageInfo.endCursor;
  }

  return allInfo;
};

export const getPostSlugs = async (): Promise<string[]> => {
  const client = getClient();

  const allSlugs: string[] = [];
  let hasNextPage = true;
  let after: string | null = null;

  const query = gql`
    ${pageInfoFragment}
    ${postSlugFragment}
    query postSlugs($after: String) {
      publication(host: "${blogHashnodeUrl}") {
        id
        posts(first: ${blogHashnodeMaxPosts}, after: $after) {
          pageInfo {
            ...PageInfoFields
          }
          edges {
            node {
              ...PostSlugFields
            }
          }
        }
      }
    }
  `;

  while (hasNextPage) {
    const data: PostSlugsQuery = await client.request<PostSlugsQuery>(query, { after: after });

    const postsData = data.publication?.posts;
    if (!postsData || !postsData.edges) {
      break; // no posts found — exit cleanly
    }

    const edges = postsData.edges;
    const pageInfo: PageInfo = data.publication.posts.pageInfo;

    allSlugs.push(...edges.map(edge => edge.node.slug));

    hasNextPage = pageInfo.hasNextPage;
    after = pageInfo.endCursor;
  }

  return allSlugs;
};

export const getAllTags = async (): Promise<TagCountInfo[]> => {
  const client = getClient();

  const tagMap = new Map<string, TagCountInfo>();
  let hasNextPage = true;
  let after: string | null = null;

  const query = gql`
    ${pageInfoFragment}
    ${postTagInfoFragment}
    query allTags($after: String) {
      publication(host: "${blogHashnodeUrl}") {
        id
        posts(first: ${blogHashnodeMaxPosts}, after: $after) {
          pageInfo {
            ...PageInfoFields
          }
          edges {
            node {
              ...PostTagInfoFields
            }
          }
        }
      }
    }
  `;

  while (hasNextPage) {
    const data: PostTagsQuery = await client.request<PostTagsQuery>(query, { after: after });

    const postsData = data.publication?.posts;
    if (!postsData || !postsData.edges) {
      break; // no posts found — exit cleanly
    }

    const edges = postsData.edges;
    const pageInfo = data.publication.posts.pageInfo;

    for (const edge of edges) {
      for (const tag of edge.node.tags) {
        if (!tagMap.has(tag.slug)) {
          tagMap.set(tag.slug, { slug: tag.slug, name: tag.name, count: 1 });
        } else {
          tagMap.get(tag.slug)!.count++;
        }
      }
    }

    hasNextPage = pageInfo.hasNextPage;
    after = pageInfo.endCursor;
  }

  return Array.from(tagMap.values());
};

type TagFilterMode = 'OR' | 'AND';

export const getAllTaggedPostInfo = async (
  tagslugs: String[],
  mode: TagFilterMode = 'OR'
): Promise<PostInfo[]> => {
  const client = getClient();

  const allInfo: PostInfo[] = [];
  let hasNextPage = true;
  let after: string | null = null;

  const query = gql`
    ${pageInfoFragment}
    ${postInfoFragment}
    query taggedPostInfo($after: String, $filter: PublicationPostConnectionFilter) {
      publication(host: "${blogHashnodeUrl}") {
        id
        posts(first: ${blogHashnodeMaxPosts}, after: $after, filter: $filter) {
          pageInfo {
            ...PageInfoFields
          }
          edges {
            node {
              ...PostInfoFields
            }
          }
        }
      }
    }
  `;

  const filter = mode === 'OR' ? {
    tagSlugs: tagslugs
  } : {
    requiredTagSlugs: tagslugs
  };

  while (hasNextPage) {
    const data: PostInfoQuery = await client.request<PostInfoQuery>(query, { after: after, filter: filter});

    const postsData = data.publication?.posts;
    if (!postsData || !postsData.edges) {
      break; // no posts found — exit cleanly
    }

    const edges = postsData.edges;
    const pageInfo: PageInfo = data.publication.posts.pageInfo;

    allInfo.push(...edges.map(edge => edge.node));

    hasNextPage = pageInfo.hasNextPage;
    after = pageInfo.endCursor;
  }

  return allInfo;
};

export const getPost = async (slug: string): Promise<Post | null> => {
  const client = getClient();

  const data = await client.request<PostQuery>(
    gql`
      ${postFragment}
      query post($slug: String!) {
        publication(host: "${blogHashnodeUrl}") {
          id
          post(slug: $slug) {
            ...PostFields
          }
        }
      }
    `,
    { slug: slug }
  );

  return data.publication.post;
};

export const getAllSeriesInfo = async (): Promise<SeriesInfo[]> => {
  const client = getClient();

  const allInfo: SeriesInfo[] = [];
  let hasNextPage = true;
  let after: string | null = null;

  const query = gql`
    ${pageInfoFragment}
    ${seriesInfoFragment}
    query allSeriesInfo($after: String) {
      publication(host: "${blogHashnodeUrl}") {
        id
        seriesList(first: ${blogHashnodeMaxSeries}, after: $after) {
          pageInfo {
            ...PageInfoFields
          }
          edges {
            node {
              ...SeriesInfoFields
            }
          }
        }
      }
    }
  `;

  while (hasNextPage) {
    const data: SeriesInfoQuery = await client.request<SeriesInfoQuery>(query, { after: after });

    const seriesList = data.publication?.seriesList;
    if (!seriesList || !seriesList.edges) {
      break; // no posts found — exit cleanly
    }

    const edges = seriesList.edges;
    const pageInfo: PageInfo = data.publication.seriesList.pageInfo;

    allInfo.push(...edges.map(edge => edge.node));

    hasNextPage = pageInfo.hasNextPage;
    after = pageInfo.endCursor;
  }

  return allInfo;
};

export const getSeries = async (slug: string): Promise<Series | null> => {
  const client = getClient();

  const data = await client.request<SeriesInitQuery>(
    gql`
      ${seriesInitFragment}
      query seriesInit($slug: String!, $first: Int!) {
        publication(host: "${blogHashnodeUrl}") {
          id
          series(slug: $slug) {
            ...SeriesInitFields
          }
        }
      }
    `,
    { slug: slug, first: blogHashnodeMaxSeries }
  );

  if (!data.publication.series) {
    return null;
  }

  let {posts, ...seriesInfo} = data.publication.series;
  let series = { ...seriesInfo, posts: posts.edges.map(edge => edge.node) };

  let hasNextPage = posts.pageInfo.hasNextPage;
  let after: string | null = posts.pageInfo.endCursor;
  
  while (hasNextPage) {
    const data: SeriesContQuery = await client.request<SeriesContQuery>(
      gql`
        ${seriesContFragment}
        query seriesCont($slug: String!, $first: Int!, $after: String!) {
          publication(host: "${blogHashnodeUrl}") {
            id
            series(slug: $slug) {
              ...SeriesContFields
            }
          }
        }
      `,
      { slug: slug, first: blogHashnodeMaxSeries, after: after }
    );

    const edges = data.publication.series.posts.edges;
    const pageInfo = data.publication.series.posts.pageInfo;

    series.posts.push(...edges.map(edge => edge.node));

    hasNextPage = pageInfo.hasNextPage;
    after = pageInfo.endCursor;
  }

  return series;
};

export const isSearchEnabled = await getPostSlugs()
  .then(slugs => slugs.length >= blogSearchLimit)
  .catch(() => false); // If the request fails, we assume search is not enabled.
