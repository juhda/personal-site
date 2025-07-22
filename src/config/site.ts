// Below should not change normally. If any does, check also in the SEO component.
export const author = "Dávid Juhász";
export const localMeImage = "/images/me.jpg"; // Relative to public folder. If you change the image, change src/assets/me.jpg as well!
export const jobTitle = "Compiler & Systems Engineer"; // This and cleanJobTitle are used at multiple places, so be careful when changing them.
export const socialLinks = {
  email: "mailto:Dávid%20Juhász<hello@davidjuhasz.dev>",
  linkedin: "https://linkedin.com/in/juhaszdavid",
  github: "https://github.com/juhda",
};
export const worksForOrgName = null;
export const siteName = `${author} - ${jobTitle}`;
export const defaultOGImage = "/og/default.png";

export const sitemapAdditionalUrls = []; // Additional URLs to include in the sitemap. This is useful for pages that are not defined as .astro files under src/pages.

// Blog-related settings.
export const blogHashnodeUrl = "davidjuhasz.dev/blog"; // Hashnode URL of the blog. This is used to fetch posts from Hashnode.
export const blogTitle = "Defined Behavior"; // Title of the blog. This is used as title in prerendered pages. On-demand pages use the blog title from Hashnode.
export const blogEnableMath = true; // Enable LaTeX math rendering in blog posts and previews.
export const blogEnableSyntaxHighlighting = true; // Enable syntax highlighting in blog posts and previews.
export const blogEnhanceCodeblocks = true; // Enable code block enhancements in blog posts.
export const blogHashnodeMaxPosts = 50; // Maximum number of posts to fetch from Hashnode at once. This is limited by Hashnode to 50.
export const blogHashnodeMaxSeries = 20; // Maximum number of series and posts within series to fetch from Hashnode at once. This is limited by Hashnode to 20.
export const blogOGImage = "/og/blog.png";
export const blogNumRecentPosts = 6; // Number of recent posts to show on the blog home. Should not be larger than blogHashnodeMaxPosts.
export const blogNumRSSPosts = 10; // Number of posts to show in the RSS feed. Should not be larger than blogHashnodeMaxPosts.
export const blogSearchLimit = 10; // Number of posts under which search is not enabled as it would not be useful for starting blogs with very few posts.
export const blogSubscribeAction = "https://buttondown.com/api/emails/embed-subscribe/definedbehavior"; // Action for blog subscribe form. Subscribe links are rendered only if provided.
export const blogSubscribeNameField = "metadata__name"; // Name of the name field in the subscribe form, which is used to identify the name of the subscriber in the posted data. If not provided, the name field is not shown.

// Your GoatCounter URL. You can find it in your GoatCounter settings.
export const goatCounterUrl = "https://stats.davidjuhasz.dev/count";

// Absolutely no need to change anything below this line.
export const cleanJobTitle = jobTitle.replace(/&/g, 'and').toLowerCase();
