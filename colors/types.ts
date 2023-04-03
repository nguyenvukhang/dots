type FgBgPair = { fg: string; bg: string }

type ColorScheme = {
  kind: 'light' | 'dark'
  /**
   * Standard terminal colors.
   * [red, green, yellow, blue, magenta, cyan]
   */
  term: [string, string, string, string, string, string]
  main: FgBgPair
  select: FgBgPair
}

class Themes {
  db: Record<string, ColorScheme>

  constructor() {
    this.db = {}
  }

  add(name: string, colorscheme: ColorScheme) {
    this.db[name] = colorscheme
  }
}

export const themes = new Themes()
