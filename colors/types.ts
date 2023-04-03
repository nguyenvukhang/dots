type BackgroundKind = "light" | "dark";
type C = string;
type TermColors = [C, C, C, C, C, C, C, C];
type Pair = { fg: C, bg: C}
export type ColorScheme = {
  kind: BackgroundKind;
  term: TermColors;
  main: Pair
  select: Pair
};
