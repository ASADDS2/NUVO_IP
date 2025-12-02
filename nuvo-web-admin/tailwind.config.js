/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {
      colors: {
        nuvo: {
          green: '#00E676',        // Primary green accent
          'dark-bg': '#0A0E1A',    // Main background - very dark blue-black
          'dark': '#161B2E',       // Card/panel background
          'card-bg': '#1A1F2E',    // Alternative card bg
          'border': '#2A2F3E',     // Borders
          'gray': '#6B7280',       // Secondary text
          'light': '#F9FAFB',      // White text
          'shadow': 'rgba(0, 230, 118, 0.2)' // Green shadow
        }
      },
      backgroundColor: {
        'dark': '#0A0E1A',
        'card': '#161B2E'
      }
    },
  },
  plugins: [],
}