/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {
      colors: {
        'nuvo-dark': '#0A0E1A',        // Fondo principal
        'nuvo-card': '#141B2D',        // Fondo de cards
        'nuvo-sidebar': '#0F1419',     // Fondo de sidebar
        'nuvo-input': '#1A2332',       // Fondo de inputs/tablas
        'nuvo-green': '#00E676',       // Verde principal
        'nuvo-blue': '#3B82F6',        // Azul para badges
        'nuvo-yellow': '#EAB308',      // Amarillo para pendientes
        'nuvo-red': '#EF4444',         // Rojo para rechazados
        'nuvo-text': '#FFFFFF',        // Texto principal
        'nuvo-text-secondary': '#9CA3AF', // Texto secundario
        'nuvo-text-disabled': '#4B5563',  // Texto deshabilitado
        'nuvo-border': 'rgba(255, 255, 255, 0.1)', // Bordes sutiles
      }
    },
  },
  plugins: [],
}