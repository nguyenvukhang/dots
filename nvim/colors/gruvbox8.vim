hi clear
let g:colors_name = 'gruvbox8'

let g:terminal_ansi_colors = ['#282828', '#ea6962', '#a9b665', '#d8a657', '#7daea3', '#d3869b', '#89b48c', '#a89984', '#928374', '#ea6962', '#a9b665', '#d8a657', '#7daea3', '#d3869b', '#89b48c', '#e5d2aa']

if has('nvim')
  let g:terminal_color_0  = '#282828'
  let g:terminal_color_1  = '#ea6962'
  let g:terminal_color_2  = '#a9b665'
  let g:terminal_color_3  = '#d8a657'
  let g:terminal_color_4  = '#7daea3'
  let g:terminal_color_5  = '#d3869b'
  let g:terminal_color_6  = '#89b48c'
  let g:terminal_color_7  = '#a89984'
  let g:terminal_color_8  = '#928374'
  let g:terminal_color_9  = '#ea6962'
  let g:terminal_color_10 = '#a9b665'
  let g:terminal_color_11 = '#d8a657'
  let g:terminal_color_12 = '#7daea3'
  let g:terminal_color_13 = '#d3869b'
  let g:terminal_color_14 = '#89b48c'
  let g:terminal_color_15 = '#e5d2aa'
endif
if get(g:, 'gruvbox_plugin_hi_groups', 0)
  " Vimshell
  let g:vimshell_escape_colors = [
    \ '#7c6f64', '#ea6962', '#a9b665', '#d8a657',
    \ '#7daea3', '#d3869b', '#89b48c', '#a89984',
    \ '#282828', '#ea6962', '#a9b665', '#e78a4e',
    \ '#7daea3', '#d3869b', '#89b48c', '#e5d2aa'
    \ ]
endif

" gruvbox additions

hi GBFg1 guifg=#e5d2aa guibg=NONE
hi GBFg2 guifg=#d5c4a1 guibg=NONE
hi GBFg3 guifg=#bdae93 guibg=NONE
hi GBFg4 guifg=#a89984 guibg=NONE
hi GBGray guifg=#928374 guibg=NONE
hi GBBg0 guifg=#282828 guibg=NONE
hi GBBg1 guifg=#3c3836 guibg=NONE
hi GBBg2 guifg=#504945 guibg=NONE
hi GBBg3 guifg=#665c54 guibg=NONE
hi GBBg4 guifg=#7c6f64 guibg=NONE

hi GBRed guifg=#ea6962 guibg=NONE
hi GBGreen guifg=#a9b665 guibg=NONE
hi GBYellow guifg=#d8a657 guibg=NONE
hi GBBlue guifg=#7daea3 guibg=NONE
hi GBPurple guifg=#d3869b guibg=NONE
hi GBAqua guifg=#89b48c guibg=NONE
hi GBOrange guifg=#e78a4e guibg=NONE

hi GBFg1Underline guifg=#e5d2aa guisp=#e5d2aa guibg=NONE gui=underline
hi GBRedUnderline guifg=#ea6962 guisp=#ea6962 guibg=NONE gui=underline
hi GBGreenUnderline guifg=#a9b665 guisp=#a9b665 guibg=NONE gui=underline
hi GBYellowUnderline guifg=#d8a657 guisp=#d8a657 guibg=NONE gui=underline
hi GBBlueUnderline guifg=#7daea3 guisp=#7daea3 guibg=NONE gui=underline
hi GBPurpleUnderline guifg=#d3869b guisp=#d3869b guibg=NONE gui=underline
hi GBAquaUnderline guifg=#89b48c guisp=#89b48c guibg=NONE gui=underline
hi GBOrangeUnderline guifg=#e78a4e guisp=#e78a4e guibg=NONE gui=underline

" custom

" latex

hi! link @markup.heading.1.latex Normal
hi! link @markup.heading.2.latex Normal
hi! link @markup.heading.3.latex Normal
hi! link @markup.heading.4.latex Normal
hi! link @markup.heading.5.latex Normal
hi! link @markup.heading.6.latex Normal
hi! link @markup.link.latex Normal
hi! link @function.macro.latex GBAqua
hi! link @function.latex GBRed
hi! link @markup.math.latex Normal
hi! link @label.latex Normal
hi! link @operator.latex GBOrange
hi! link @markup.link.url.latex GBGray
 
" treesitter[lua]
hi! link @variable Normal
hi! link @keyword.function.lua GBGreen
hi! link @keyword.operator.lua GBBlue
hi! link @keyword.vim String
hi! link @function.builtin.lua GBBlue
hi! link @function.call.lua Normal
hi! link @function.lua Normal
hi! link @function.method.call.lua GBBlue
hi! link @property.lua Normal
hi! link @punctuation.bracket.lua Normal
hi! link @punctuation.delimiter.lua Normal
hi! link @constructor.lua GBBlue
hi! link @constant.builtin.lua GBPurple

" treesitter[markdown]
hi! link @punctuation.special.markdown GBGray

" others

hi! link @javaDocComment GBGray
hi! link @spe GBGray

hi! link texDocZone Normal
hi! link texSectionZone Normal
hi! link texSubSectionZone Normal
hi! link texOnlyMath Normal

hi! link markdownError Normal
hi! link htmlError Normal

hi UniversalBorder guifg=#504945 guibg=NONE guisp=NONE gui=NONE

hi! link TelescopeNormal Normal
hi! link TelescopePromptPrefix Identifier
hi! link TelescopePrompt TelescopeNormal
hi! link TelescopePromptCounter TelescopeNormal
hi TelescopeSelection guifg=NONE guibg=#3c3836 guisp=NONE gui=NONE
hi! link TelescopeSelectionCaret GBGreen
hi! link TelescopeBorder GBFg1
hi! link TelescopeMatching Special
hi! link TelescopeResultsBorder UniversalBorder
hi! link TelescopePreviewBorder UniversalBorder
hi! link TelescopePromptBorder UniversalBorder

hi! link rustCommentLineDoc Comment

hi! link HarpoonWindow Normal
hi! link HarpoonBorder UniversalBorder

" LSP Diagnostic
hi! link DiagnosticError GBRed
hi! link DiagnosticSignError GBRed
hi! link DiagnosticUnderlineError GBRedUnderline
hi! link DiagnosticVirtualTextError GBRed
hi! link DiagnosticFloatingError GBRed

hi! link DiagnosticWarn GBYellow
hi! link DiagnosticSignWarn GBYellow
hi! link DiagnosticUnderlineWarn GBYellowUnderline
hi! link DiagnosticVirtualTextWarn GBYellow
hi! link DiagnosticFloatingWarn GBYellow

hi! link DiagnosticInfo GBBlue
hi! link DiagnosticSignInfo GBBlue
hi! link DiagnosticUnderlineInfo GBBlueUnderline
hi! link DiagnosticVirtualTextInfo GBBlue
hi! link DiagnosticFloatingInfo GBBlue

hi! link DiagnosticHint GBOrange
hi! link DiagnosticSignHint GBOrange
hi! link DiagnosticUnderlineHint GBOrangeUnderline
hi! link DiagnosticVirtualTextHint GBOrange
hi! link DiagnosticFloatingHint GBOrange

hi! link DiagnosticUnnecessary GBFg1Underline

" standard links

hi! link CurSearch Search
hi! link CursorColumn CursorLine
hi! link CursorLineFold FoldColumn
hi! link CursorLineSign SignColumn
hi! link LineNrAbove LineNr
hi! link LineNrBelow LineNr
hi! link PopupNotification WarningMsg
hi! link PopupSelected PmenuSel
hi! link QuickFixLine Search
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! link Tag Special
hi! link TermCursor Cursor
hi! link VisualNOS Visual
hi! link debugBreakpoint SignColumn
hi! link debugPC SignColumn
hi! link iCursor Cursor
hi! link lCursor Cursor
hi! link vCursor Cursor

" standard colors

hi Normal guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
hi NormalFloat guifg=#e5d2aa guibg=#3c3836 guisp=NONE gui=NONE
hi FloatBorder guifg=#e5d2aa guibg=#504945 guisp=NONE gui=NONE
hi Boolean guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
hi Character guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
hi ColorColumn guifg=NONE guibg=#3c3836 guisp=NONE gui=NONE
hi CommandMode guifg=#d3869b guibg=#282828 guisp=NONE gui=reverse
hi Comment guifg=#928374 guibg=NONE guisp=NONE
hi Conceal guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
hi Conditional guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
hi Constant guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
hi Cursor guifg=NONE guibg=NONE guisp=NONE gui=reverse
hi CursorIM guifg=NONE guibg=NONE guisp=NONE gui=reverse
hi CursorLine guifg=NONE guibg=#3c3836 guisp=NONE gui=NONE
hi CursorLineNr guifg=#d8a657 guibg=#3c3836 guisp=NONE gui=NONE
hi Debug guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
hi Define guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
hi Delimiter guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
hi DiffAdd guifg=#a9b665 guibg=#282828 guisp=NONE gui=reverse
hi DiffChange guifg=#89b48c guibg=#282828 guisp=NONE gui=reverse
hi DiffDelete guifg=#ea6962 guibg=#282828 guisp=NONE gui=reverse
hi DiffText guifg=#d8a657 guibg=#282828 guisp=NONE gui=reverse
hi Directory guifg=#a9b665 guibg=NONE guisp=NONE gui=bold
hi EndOfBuffer guifg=#282828 guibg=NONE guisp=NONE gui=NONE
hi Error guifg=#ea6962 guibg=#282828 guisp=NONE gui=bold,reverse
hi ErrorMsg guifg=#282828 guibg=#ea6962 guisp=NONE gui=bold
hi Exception guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
hi Float guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
hi FoldColumn guifg=#928374 guibg=#3c3836 guisp=NONE gui=NONE
hi Folded guifg=#928374 guibg=#3c3836 guisp=NONE
hi Function guifg=#a9b665 guibg=NONE guisp=NONE gui=bold
hi Identifier guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
hi Ignore guifg=fg guibg=NONE guisp=NONE gui=NONE
hi IncSearch guifg=#e78a4e guibg=#282828 guisp=NONE gui=reverse
hi Include guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
hi InsertMode guifg=#7daea3 guibg=#282828 guisp=NONE gui=reverse
hi Keyword guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
hi Label guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
hi LineNr guifg=#7c6f64 guibg=NONE guisp=NONE gui=NONE
hi Macro guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
hi MatchParen guifg=NONE guibg=#504945 guisp=NONE gui=bold,underline
hi ModeMsg guifg=#d8a657 guibg=NONE guisp=NONE gui=bold
hi MoreMsg guifg=#d8a657 guibg=NONE guisp=NONE gui=bold
hi NonText guifg=#504945 guibg=NONE guisp=NONE gui=NONE
hi NormalMode guifg=#a89984 guibg=#282828 guisp=NONE gui=reverse
hi Number guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
hi Operator guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
hi Pmenu guifg=#e5d2aa guibg=#504945 guisp=NONE gui=NONE
hi PmenuKind guifg=#e78a4e guibg=#504945 guisp=NONE gui=NONE
hi PmenuSbar guifg=NONE guibg=#504945 guisp=NONE gui=NONE
hi PmenuSel guifg=#504945 guibg=#7daea3 guisp=NONE gui=bold
hi PmenuThumb guifg=NONE guibg=#7c6f64 guisp=NONE gui=NONE
hi PreCondit guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
hi PreProc guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
hi Question guifg=#e78a4e guibg=NONE guisp=NONE gui=bold
hi Repeat guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
hi ReplaceMode guifg=#89b48c guibg=#282828 guisp=NONE gui=reverse
hi Search guifg=#d8a657 guibg=#282828 guisp=NONE gui=reverse
hi SignColumn guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
hi Special guifg=#e78a4e guibg=NONE guisp=NONE
hi SpecialChar guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
hi SpecialComment guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
hi SpecialKey guifg=#928374 guibg=NONE guisp=NONE gui=NONE
hi SpellBad guifg=#ea6962 guibg=NONE guisp=#ea6962 gui=undercurl
hi SpellCap guifg=#7daea3 guibg=NONE guisp=#7daea3 gui=undercurl
hi SpellLocal guifg=#89b48c guibg=NONE guisp=#89b48c gui=undercurl
hi SpellRare guifg=#d3869b guibg=NONE guisp=#d3869b gui=undercurl
hi Statement guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
hi WinSeparator guifg=#504945 guibg=NONE guisp=NONE gui=NONE
hi StatusLine guifg=#504945 guibg=#e5d2aa guisp=NONE gui=reverse
hi StatusLineBranch guifg=#504945 guibg=#a89984 guisp=NONE gui=reverse
hi StatusLineNC guifg=#504945 guibg=#a89984 guisp=NONE gui=reverse
hi StorageClass guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
hi String guifg=#a9b665 guibg=NONE guisp=NONE
hi Structure guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
hi TabLine guifg=#7c6f64 guibg=#3c3836 guisp=NONE gui=NONE
hi TabLineFill guifg=#7c6f64 guibg=#3c3836 guisp=NONE gui=NONE
hi TabLineSel guifg=#a9b665 guibg=#3c3836 guisp=NONE gui=NONE
hi TermCursorNC guifg=#3c3836 guibg=#e5d2aa guisp=NONE gui=NONE
hi Terminal guifg=#e5d2aa guibg=#282828 guisp=NONE gui=NONE
hi Title guifg=#a9b665 guibg=NONE guisp=NONE gui=bold
hi Todo guifg=fg guibg=#282828 guisp=NONE gui=bold
hi ToolbarButton guifg=e5d2aa guibg=#665c54 guisp=NONE gui=bold
hi ToolbarLine guifg=NONE guibg=#665c54 guisp=NONE gui=NONE
hi Type guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
hi Typedef guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
hi Underlined guifg=#7daea3 guibg=NONE guisp=#7daea3 gui=underline
hi VertSplit guifg=#504945 guibg=NONE guisp=NONE gui=NONE
hi Visual guifg=NONE guibg=#665c54 guisp=NONE gui=NONE
hi VisualMode guifg=#e78a4e guibg=#282828 guisp=NONE gui=reverse
hi WarningMsg guifg=#ea6962 guibg=NONE guisp=NONE gui=bold
hi Warnings guifg=#e78a4e guibg=#282828 guisp=NONE gui=reverse
hi WildMenu guifg=#7daea3 guibg=#504945 guisp=NONE gui=bold

if has('gui_running')
  hi Directory gui=NONE
  hi Error gui=reverse
  hi ErrorMsg gui=NONE
  hi Function gui=NONE
  hi MatchParen gui=underline
  hi ModeMsg gui=NONE
  hi MoreMsg gui=NONE
  hi PmenuSel gui=NONE
  hi Question gui=NONE
  hi Title gui=NONE
  hi ToolbarButton gui=NONE
  hi WarningMsg gui=NONE
  hi WildMenu gui=NONE
  hi Todo gui=NONE
  hi cOperator guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi cStructure guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi clojureAnonArg guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi clojureCharacter guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi clojureCond guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi clojureDefine guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi clojureDeref guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi clojureException guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi clojureFunc guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi clojureKeyword guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi clojureMacro guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi clojureMeta guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi clojureParen guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi clojureQuote guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi clojureRegexp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi clojureRegexpEscape guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi! link clojureRegexpMod clojureRegexpCharClass
  hi! link clojureRegexpQuantifier clojureRegexpCharClass
  hi clojureRepeat guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi clojureSpecial guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi clojureStringEscape guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi clojureUnquote guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi clojureVariable guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi coffeeBracket guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi coffeeCurly guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi coffeeExtendedOp guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi coffeeParen guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi coffeeSpecialOp guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi cssAnimationProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssBackgroundProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssBorderOutlineProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssBoxProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssBraces guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi cssClassName guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi cssColor guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi cssColorProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssDimensionProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssFlexibleBoxProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssFontDescriptorProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssFontProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssFunctionName guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi cssGeneratedContentProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssIdentifier guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi cssImportant guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi cssListProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssMarginProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssPaddingProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssPositioningProp guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi cssPrintProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssRenderProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssSelectorOp guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi cssSelectorOp2 guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi cssTableProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssTextProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssTransformProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssTransitionProp guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi cssUIProp guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi cssVendor guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi diffAdded guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi diffChanged guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi diffFile guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi diffLine guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi diffNewFile guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi diffRemoved guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi dtdFunction guifg=#928374 guibg=NONE guisp=NONE gui=NONE
  hi dtdParamEntityDPunct guifg=#928374 guibg=NONE guisp=NONE gui=NONE
  hi dtdParamEntityPunct guifg=#928374 guibg=NONE guisp=NONE gui=NONE
  hi dtdTagName guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi! link elixirDocString Comment
  hi elixirInterpolationDelimiter guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi elixirModuleDeclaration guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi elixirStringDelimiter guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi goBuiltins guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi goConstants guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi goDeclType guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi goDeclaration guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi goDirective guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi haskellAssocType guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi haskellBacktick guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi haskellBlockKeywords guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi haskellBottom guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi haskellChar guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi haskellConditional guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi haskellDeclKeyword guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi haskellDefault guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi haskellDelimiter guifg=#a89984 guibg=NONE guisp=NONE gui=NONE
  hi haskellDeriving guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi haskellIdentifier guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi haskellImportKeywords guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi haskellLet guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi haskellNumber guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi haskellOperators guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi haskellPragma guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi haskellSeparator guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi haskellStatement guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi haskellString guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi haskellType guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi haskellWhere guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi htmlArg guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi htmlEndTag guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi htmlItalic guifg=fg guibg=#282828 guisp=NONE
  hi htmlLink guifg=#a89984 guibg=NONE guisp=NONE gui=underline
  hi htmlScriptTag guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi htmlSpecialChar guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi htmlTag guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi htmlTagN guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi htmlTagName guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi htmlUnderline guifg=fg guibg=#282828 guisp=NONE gui=underline
  hi htmlUnderlineItalic guifg=fg guibg=#282828 guisp=NONE gui=underline
  hi javaAnnotation guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi! link javaCommentTitle vimCommentTitle
  hi javaDocTags guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi javaOperator guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi javaParen guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi javaParen1 guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi javaParen2 guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi javaParen3 guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi javaParen4 guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi javaParen5 guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi javaScriptBraces guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javaScriptFunction guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi javaScriptIdentifier guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi javaScriptMember guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi javaScriptNull guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi javaScriptNumber guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi javaScriptParens guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi javaVarArg guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi javascriptArrayMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptArrayStaticMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptArrowFunc guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi javascriptAsyncFunc guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi javascriptAsyncFuncKeyword guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi javascriptAwaitFuncKeyword guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi javascriptBOMLocationMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptBOMNavigatorProp guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptBOMWindowMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptBOMWindowProp guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptBrackets guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptCacheMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptClassExtends guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi javascriptClassKeyword guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi javascriptClassName guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi javascriptClassStatic guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi javascriptClassSuper guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi javascriptClassSuperName guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi javascriptDOMDocMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptDOMDocProp guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptDOMElemAttrs guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptDOMEventMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptDOMNodeMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptDOMStorageMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptDateMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptDefault guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi javascriptDocNamedParamType guifg=#a89984 guibg=NONE guisp=NONE gui=NONE
  hi javascriptDocNotation guifg=#a89984 guibg=NONE guisp=NONE gui=NONE
  hi javascriptDocParamName guifg=#a89984 guibg=NONE guisp=NONE gui=NONE
  hi javascriptDocParamType guifg=#a89984 guibg=NONE guisp=NONE gui=NONE
  hi javascriptDocTags guifg=#a89984 guibg=NONE guisp=NONE gui=NONE
  hi javascriptEndColons guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptExceptions guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi javascriptExport guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi javascriptForOperator guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi javascriptFuncArg guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptFuncKeyword guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi javascriptGlobal guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi javascriptGlobalMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptHeadersMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptIdentifier guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi javascriptImport guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi javascriptLabel guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptLogicSymbols guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptMathStaticMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptMessage guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi javascriptNodeGlobal guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptObjectLabel guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptOperator guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi javascriptPropertyName guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptStringMethod guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptTemplateSB guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi javascriptTemplateSubstitution guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptURLUtilsProp guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi javascriptVariable guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi javascriptYield guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi jsBracket guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi jsClassBlock guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsClassDefinition guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi jsClassKeyword guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi jsClassProperty guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi jsDestructuringBlock guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi jsExport guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi jsExtendsKeyword guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi jsFrom guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi jsFuncBlock guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsFuncBraces guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi jsFuncParens guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi jsFunction guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi jsFunctionKey guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi jsGlobalNodeObjects guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi jsGlobalObjects guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi jsImport guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi jsModuleKeyword guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsNull guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi jsObjectColon guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi jsObjectProp guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsObjectShorthandProp guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsObjectValue guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsOperator guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi jsParen guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsParenIfElse guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsParens guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi jsSpreadExpression guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsSpreadOperator guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi jsStorageClass guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi jsTemplateBraces guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi jsThis guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi jsUndefined guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi jsVariableDef guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi jsonBraces guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi jsonKeyword guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi jsonQuote guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi jsonString guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi jsxAttrib guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi jsxAttributeBraces guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi jsxCloseString guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsxCloseTag guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsxComponentName guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi jsxDot guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi jsxElseOperator guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi jsxEndString guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsxEndTag guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsxEqual guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi jsxEscapeJsAttributes guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsxEscapeJsContent guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsxIfOperator guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi jsxNamespace guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsxPunct guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi jsxRegion guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi jsxString guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi jsxTagName guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi luaFunction guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi luaIn guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi luaTable guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi markdownBlockquote guifg=#928374 guibg=NONE guisp=NONE gui=NONE
  hi markdownCode guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi markdownCodeBlock guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi markdownCodeDelimiter guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi markdownH5 guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi markdownH6 guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi markdownHeadingDelimiter guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi markdownHeadingRule guifg=#928374 guibg=NONE guisp=NONE gui=NONE
  hi! link markdownIdDeclaration markdownLinkText
  hi markdownItalic guifg=#bdae93 guibg=NONE guisp=NONE
  hi markdownLinkDelimiter guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi markdownLinkText guifg=#928374 guibg=NONE guisp=NONE gui=underline
  hi markdownLinkTextDelimiter guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi markdownListMarker guifg=#928374 guibg=NONE guisp=NONE gui=NONE
  hi markdownOrderedListMarker guifg=#928374 guibg=NONE guisp=NONE gui=NONE
  hi markdownRule guifg=#928374 guibg=NONE guisp=NONE gui=NONE
  hi markdownUrl guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi markdownUrlDelimiter guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi markdownUrlTitleDelimiter guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi moonExtendedOp guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi moonFunction guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi moonObject guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi moonSpecialOp guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi objcDirective guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi objcTypeModifier guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi purescriptAsKeyword guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi purescriptBacktick guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi purescriptConditional guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi purescriptConstructor guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi purescriptDelimiter guifg=#a89984 guibg=NONE guisp=NONE gui=NONE
  hi purescriptFunction guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi purescriptHidingKeyword guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi purescriptImportKeyword guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi purescriptModuleKeyword guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi purescriptModuleName guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi purescriptOperator guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi purescriptStructure guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi purescriptType guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi purescriptTypeVar guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi purescriptWhere guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi pythonBoolean guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi pythonBuiltin guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi pythonBuiltinFunc guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi pythonBuiltinObj guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi pythonCoding guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi pythonConditional guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi pythonDecorator guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi pythonDot guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi pythonException guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi pythonExceptions guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi pythonFunction guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi pythonImport guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi pythonInclude guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi pythonOperator guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi pythonRepeat guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi pythonRun guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi rubyInterpolationDelimiter guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi rubyStringDelimiter guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi scalaCapitalWord guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi scalaCaseFollowing guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi scalaInstanceDeclaration guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi scalaInterpolation guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi scalaKeyword guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi scalaKeywordModifier guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi scalaNameDefinition guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi scalaOperator guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi scalaSpecial guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi scalaTypeDeclaration guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi scalaTypeExtension guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi scalaTypeTypePostDeclaration guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi typeScriptAjaxMethods guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi typeScriptBraces guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi typeScriptDOMObjects guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi! link typeScriptDocParam Comment
  hi! link typeScriptDocSeeTag Comment
  hi! link typeScriptDocTags vimCommentTitle
  hi typeScriptEndColons guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi typeScriptFuncKeyword guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi typeScriptGlobalObjects guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi typeScriptHtmlElemProperties guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi typeScriptIdentifier guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi typeScriptInterpolationDelimiter guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi typeScriptLabel guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi typeScriptLogicSymbols guifg=#e5d2aa guibg=NONE guisp=NONE gui=NONE
  hi typeScriptNull guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi typeScriptOpSymbols guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi typeScriptParens guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi typeScriptReserved guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi vimBracket guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi vimContinue guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi vimFuncSID guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi vimMapModKey guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi vimNotation guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi vimSep guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi vimSetSep guifg=#bdae93 guibg=NONE guisp=NONE gui=NONE
  hi xmlAttrib guifg=#89b48c guibg=NONE guisp=NONE gui=NONE
  hi xmlAttribPunct guifg=#928374 guibg=NONE guisp=NONE gui=NONE
  hi xmlCdataCdata guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi xmlCdataStart guifg=#928374 guibg=NONE guisp=NONE gui=NONE
  hi xmlDocTypeDecl guifg=#928374 guibg=NONE guisp=NONE gui=NONE
  hi xmlDocTypeKeyword guifg=#d3869b guibg=NONE guisp=NONE gui=NONE
  hi xmlEndTag guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi xmlEntity guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi xmlEntityPunct guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi xmlEqual guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi xmlProcessingDelim guifg=#928374 guibg=NONE guisp=NONE gui=NONE
  hi xmlTag guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi xmlTagName guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi Comment gui=NONE
  hi Folded gui=NONE
  hi SpellBad gui=undercurl
  hi SpellCap gui=undercurl
  hi SpellLocal gui=undercurl
  hi SpellRare gui=undercurl
  hi Special gui=NONE
  hi String gui=NONE
  hi BufTabLineActive guifg=#a89984 guibg=#504945 guisp=NONE gui=NONE
  hi BufTabLineCurrent guifg=#282828 guibg=#a89984 guisp=NONE gui=NONE
  hi BufTabLineFill guifg=#282828 guibg=#282828 guisp=NONE gui=NONE
  hi BufTabLineHidden guifg=#7c6f64 guibg=#3c3836 guisp=NONE gui=NONE
  hi LangaugeClientInfo guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi LanguageClientCodeLens guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi LanguageClientError guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi LanguageClientErrorSign guifg=#ea6962 guibg=#282828 guisp=NONE gui=NONE
  hi LanguageClientInfoSign guifg=#7daea3 guibg=#3c3836 guisp=NONE gui=NONE
  hi LanguageClientWarning guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi LanguageClientWarningSign guifg=#d8a657 guibg=#3c3836 guisp=NONE gui=NONE
  hi LspDiagnosticsDefaultError guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi LspDiagnosticsDefaultHint guifg=#7daea3 guibg=NONE guisp=NONE gui=NONE
  hi LspDiagnosticsDefaultInformation guifg=#d8a657 guibg=NONE guisp=NONE gui=NONE
  hi LspDiagnosticsDefaultWarning guifg=#e78a4e guibg=NONE guisp=NONE gui=NONE
  hi LspDiagnosticsSignError guifg=#ea6962 guibg=#3c3836 guisp=NONE gui=NONE
  hi LspDiagnosticsSignHint guifg=#7daea3 guibg=#3c3836 guisp=NONE gui=NONE
  hi LspDiagnosticsSignInformation guifg=#d8a657 guibg=#3c3836 guisp=NONE gui=NONE
  hi LspDiagnosticsSignWarning guifg=#e78a4e guibg=#3c3836 guisp=NONE gui=NONE
  hi LspDiagnosticsUnderlineError guifg=NONE guibg=NONE guisp=NONE gui=NONE
  hi LspDiagnosticsUnderlineHint guifg=NONE guibg=NONE guisp=NONE gui=NONE
  hi LspDiagnosticsUnderlineInformation guifg=NONE guibg=NONE guisp=NONE gui=NONE
  hi LspDiagnosticsUnderlineWarning guifg=NONE guibg=NONE guisp=NONE gui=NONE
  hi SignatureMarkText guifg=#7daea3 guibg=#3c3836 guisp=NONE gui=NONE
  hi SignatureMarkerText guifg=#d3869b guibg=#3c3836 guisp=NONE gui=NONE
  hi gitcommitDiscardedFile guifg=#ea6962 guibg=NONE guisp=NONE gui=NONE
  hi gitcommitSelectedFile guifg=#a9b665 guibg=NONE guisp=NONE gui=NONE
  hi multiple_cursors_cursor guifg=NONE guibg=NONE guisp=NONE gui=reverse
  hi multiple_cursors_visual guifg=NONE guibg=#504945 guisp=NONE gui=NONE
endif

" vim: et ts=8 sw=2 sts=2
