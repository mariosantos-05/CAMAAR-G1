module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          purple: '#5D1F5D',
          green: '#22C55E',
        },
        bg: {
          main: '#E5E5E5',
        },
        surface: {
          white: '#FFFFFF',
        }
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
      }
    },
  },
  plugins: [
    // Se der erro aqui, remova a linha do require forms temporariamente
    // ou certifique-se de que o plugin está instalado
    // require('@tailwindcss/forms'),
  ],
}