import { gql } from "graphql-request";

// NOTE: Hashnode GraphQL Caching: You need to request the field id of each field.
// It is best practice to always request the id. If you don't do that, it is possible that you get stale data.
// That's why all gql fragments have the id field in them wherever applicable,
// while id is not reflected in corresponding interfaces.

export const textContentFragment = gql`
  fragment TextContentFields on Content {
    text
  }
`;

export interface TextContent {
    text: string;
}

export const ogMetaDataFragment = gql`
  fragment OgMetaDataFields on OpenGraphMetaData {
    image
  }
`;

export interface OgMetaData {
    image: string;
}

export const authorFragment = gql`
  fragment AuthorFields on User {
    id
    name
    profilePicture
    username
  }
`;

export interface Author {
    name: string;
    profilePicture: string;
    username: string;
}

export const blogInfoFragment = gql`
  ${textContentFragment}
  ${ogMetaDataFragment}
  ${authorFragment}
  fragment BlogInfoFields on Publication {
    id
    title
    displayTitle
    about {
      ...TextContentFields
    }
    ogMetaData {
      ...OgMetaDataFields
    }
    author {
      ...AuthorFields
    }
  }
`;

export interface BlogInfo {
    title: string;
    displayTitle: string;
    about: TextContent;
    ogMetaData: OgMetaData;
    author: Author;
}

export interface BlogInfoQuery {
    publication: BlogInfo;
}

export const postSlugFragment = gql`
  fragment PostSlugFields on Post {
    id
    slug
  }
`;

export interface Slug {
  slug: string;
}

export const tagInfoFragment = gql`
  fragment TagInfoFields on Tag {
    slug
    name
  }
`;

export interface TagInfo extends Slug {
  name: string;
}

export interface TagCountInfo extends TagInfo {
  count: number;
}

export const postTagInfoFragment = gql`
  ${tagInfoFragment}
  fragment PostTagInfoFields on Post {
    id
    tags {
      ...TagInfoFields
    }
  }
`;

export interface PostTagInfo {
  tags: TagInfo[];
}

export const postBannerImageFragment = gql`
  fragment PostBannerImageFields on PostBannerImage {
    url
  }
`;

export interface PostBannerImage {
  url: string;
}

export const postInfoFragment = gql`
  ${postSlugFragment}
  ${postTagInfoFragment}
  ${postBannerImageFragment}
  fragment PostInfoFields on Post {
    id
    ...PostSlugFields
    ...PostTagInfoFields
    publishedAt
    title
    subtitle
    brief
    bannerImage {
      ...PostBannerImageFields
    }
  }
`;

export interface PostInfo extends Slug, PostTagInfo {
    publishedAt: string;
    title: string;
    subtitle: string;
    brief: string;
    bannerImage: PostBannerImage;
}

export const pageInfoFragment = gql`
  fragment PageInfoFields on PageInfo {
    hasNextPage
    endCursor
  }
`;

export interface PageInfo {
    hasNextPage: boolean;
    endCursor: string;
}

export interface PostSlugsQuery {
  publication: {
    posts: {
      pageInfo: PageInfo;
      edges: {
          node: Slug;
      }[];
    };
  };
}

export interface PostTagsQuery {
  publication: {
    posts: {
      pageInfo: PageInfo;
      edges: {
          node: PostTagInfo;
      }[];
    };
  };
}

export interface PostInfoQuery {
    publication: {
        posts: {
            pageInfo: PageInfo;
            edges: {
                node: PostInfo;
            }[];
        };
    };
}

export interface PinnedPostInfoQuery {
  publication: {
      pinnedPost: PostInfo;
  };
}

export const postCoverImageFragment = gql`
  fragment PostCoverImageFields on PostCoverImage {
    url
  }
`;

export interface PostCoverImage {
  url: string;
}


export const seriesBaseInfoFragment = gql`
  fragment SeriesBaseInfoFields on Series {
    id
    slug
    name
  }
`;

export interface SeriesBaseInfo extends Slug {
  name: string;
}

export const contentFragment = gql`
  fragment ContentFields on Content {
    html
  }
`;

export interface Content {
    html: string;
}

export const seoFragment = gql`
  fragment SeoFields on SEO {
    title
    description
  }
`;

export interface Seo {
    title: string;
    description: string;
}

export const postFragment = gql`
  ${postInfoFragment}
  ${authorFragment}
  ${postCoverImageFragment}
  ${seriesBaseInfoFragment}
  ${contentFragment}
  ${seoFragment}
  ${ogMetaDataFragment}
  fragment PostFields on Post {
    id
    ...PostInfoFields
    author {
      ...AuthorFields
    }
    coAuthors {
      ...AuthorFields
    }
    updatedAt
    canonicalUrl
    coverImage {
      ...PostCoverImageFields
    }
    series {
      ...SeriesBaseInfoFields
    }
    content {
      ...ContentFields
    }
    seo {
      ...SeoFields
    }
    ogMetaData {
      ...OgMetaDataFields
    }
  }
`;

export interface Post extends PostInfo {
    author: Author;
    coAuthors: Author[];
    updatedAt: string;
    canonicalUrl: string;
    coverImage: PostCoverImage;
    series: SeriesBaseInfo;
    content: Content;
    seo: Seo;
    ogMetaData: OgMetaData;
}

export interface PostQuery {
  publication: {
      post: Post;
  };
}

export const seriesInfoFragment = gql`
  ${seriesBaseInfoFragment}
  ${contentFragment}
  fragment SeriesInfoFields on Series {
    id
    ...SeriesBaseInfoFields
    coverImage
    description {
      ...ContentFields
    }
  }
`;

export interface SeriesInfo extends SeriesBaseInfo {
  coverImage: string;
  description: Content;
}

export interface SeriesInfoQuery {
  publication: {
    seriesList: {
      pageInfo: PageInfo;
      edges: {
          node: SeriesInfo;
      }[];
    };
  };
}

export const seriesInitFragment = gql`
  ${seriesInfoFragment}
  ${postInfoFragment}
  ${pageInfoFragment}
  fragment SeriesInitFields on Series {
    id
    ...SeriesInfoFields
    posts(first: $first) {
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
`;

export interface SeriesInitQuery {
  publication: {
    series: SeriesInfo & {
      posts: {
        pageInfo: PageInfo;
        edges: {
          node: PostInfo;
        }[];
      };
    };
  };
}

export const seriesContFragment = gql`
  ${postInfoFragment}
  ${pageInfoFragment}
  fragment SeriesContFields on Series {
    posts(first: $first, after: $after) {
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
`;

export interface SeriesContQuery {
  publication: {
    series: {
      posts: {
        pageInfo: PageInfo;
        edges: {
          node: PostInfo;
        }[];
      };
    }
  };
}

export interface Series extends SeriesInfo {
  posts: PostInfo[];
}
