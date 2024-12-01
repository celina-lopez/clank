const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  daisyui: {
    themes: ['fantasy', 'dracula']
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
    require("daisyui"),
  ],
  safelist: [
    {
      pattern: /text-(amber|red|yellow|sky|green)-600/,
    },
    {
      pattern: /bg-(red|yellow|blue|green|pink|teal|orange|cyan|violet)-400/,
    },
    {
      pattern: /border-(red|yellow|blue|green|pink|teal|orange|cyan|violet)-400/,
    },
    'opacity-100',
    'delay-500',
  ]
}
