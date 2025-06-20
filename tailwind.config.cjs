/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'media', // use browser/system settings for dark mode
  content: [
    "./src/**/*.{astro,html,js,jsx,ts,tsx,vue,svelte}"
  ],
  theme: {
    extend: {
      colors: {
        primary: 'var(--primary)',
        accent: 'var(--accent)',
        muted: 'var(--muted)',
        surface: 'var(--surface)',
        highlight: 'var(--highlight)',
        text: 'var(--text)',
        heading: 'var(--heading)',
        bg: 'var(--bg)',
      },
      fontFamily: {
        title: ['var(--font-title)'],
        body: ['var(--font-body)'],
      },
    },
  },
  plugins: [],
}
