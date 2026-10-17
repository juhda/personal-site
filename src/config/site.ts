// Below should not change normally. If any does, check also in the SEO component.
export const author = "Dávid Juhász";
export const localMeImage = "/images/me.jpg"; // Relative to public folder. If you change the image, change src/assets/me.jpg as well!
export const jobTitle = "Software Consultant"; // This and cleanJobTitle are used at multiple places, so be careful when changing them.
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
export const blogTitle = "Defined Behavior"; // Title of the blog.
export const blogDescriptionSEO = "Engineering at the intersection of software and hardware. Structured thinking on systems, compilers, and technical leadership — with clarity, precision, and purpose."; // SEO description of the blog.
export const blogOGImage = "/og/blog.png";
export const blogNumRecentPosts = 6; // Number of recent posts to show on the blog home.
export const blogNumRSSPosts = 10; // Number of posts to show in the RSS feed.
export const blogSearchLimit = 10; // Number of posts under which search is not enabled as it would not be useful for starting blogs with very few posts.
export const blogSubscribeAction = "https://buttondown.com/api/emails/embed-subscribe/definedbehavior"; // Action for blog subscribe form. Subscribe links are rendered only if provided.
export const blogSubscribeNameField = "metadata__name"; // Name of the name field in the subscribe form, which is used to identify the name of the subscriber in the posted data. If not provided, the name field is not shown.

// Your GoatCounter URL. You can find it in your GoatCounter settings.
export const goatCounterUrl = "https://stats.davidjuhasz.dev/count";

// Absolutely no need to change anything below this line.
export const cleanJobTitle = jobTitle.replace(/&/g, 'and');
