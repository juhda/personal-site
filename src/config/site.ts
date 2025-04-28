// Below should not change normally. If any does, check also in the SEO component.
export const author = "Dávid Juhász";
export const localMeImage = "/images/me.jpg"; // Relative to public folder. If you change the image, change src/assets/me.jpg as well!
export const jobTitle = "Compiler & Systems Engineer"; // This and cleanJobTitle are used at multiple places, so be careful when changing them.
export const socialLinks = {
  email: "mailto:hello@davidjuhasz.dev",
  linkedin: "https://linkedin.com/in/juhaszdavid",
  github: "https://github.com/juhda",
};
export const worksForOrgName = null;
export const siteName = `${author} - ${jobTitle}`;
export const defaultOGImage = "/og/default.png";

// Your GoatCounter URL. You can find it in your GoatCounter settings.
export const goatCounterUrl = "https://stats.davidjuhasz.dev/count";

// Absolutely no need to change anything below this line.
export const cleanJobTitle = jobTitle.replace(/&/g, 'and').toLowerCase();
