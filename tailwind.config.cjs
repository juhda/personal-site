/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{astro,html,js,jsx,ts,tsx,vue,svelte}"
  ],
  theme: {
    extend: {
      colors: {
        primary: '#1A202C',
        accent: '#4F46E5',
        muted: '#E2E8F0',
        surface: '#F7FAFC',
        highlight: '#10B981',
      }
    },
  },
  plugins: [],
}
