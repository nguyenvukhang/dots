import { themes } from './types'

themes.add('gruvbox', {
  kind: 'dark',
  term: ['#fb4934', '#b8bb26', '#fabd2f', '#83a598', '#d3869b', '#8ec07c'],
  main: { bg: '#282828', fg: '#ebdbb2' },
  select: { bg: '#ebdbb2', fg: '#504945' },
})

console.log(themes)
