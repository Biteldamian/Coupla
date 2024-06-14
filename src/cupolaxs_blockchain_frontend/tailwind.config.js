/** @type {import('tailwindcss').Config} */
export default {
  darkMode: 'media',
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
    "../../node_modules/flowbite/**/*.js",
  ],
  theme: {
    extend: {
      colors: {
        // Add custom colors here
        primary: '#1DA1F2',
        secondary: '#14171A',
      },
      fontFamily: {
        // Add custom fonts here
        sans: ['Inter', 'sans-serif'],
      },
    },
  },
  plugins: [
    require('flowbite/plugin')
  ],
}

