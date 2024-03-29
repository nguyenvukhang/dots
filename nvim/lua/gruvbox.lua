local M = {}

-- stylua: ignore start
local colors = {
  bg0 = '#282828', bg1 = '#3c3836', bg2 = '#504945', bg3 = '#665c54', bg4 = '#7c6f64',
  fg0 = '#fbf1c7', fg1 = '#ebdbb2', fg2 = '#d5c4a1', fg3 = '#bdae93', fg4 = '#a89984',
  red = '#fb4934',
  green = '#b8bb26',
  yellow = '#fabd2f',
  blue = '#83a598',
  purple = '#d3869b',
  aqua = '#8ec07c',
  orange = '#fe8019',
  gray = '#928374',
}

local material = {
  bg0 = '#282828', bg1 = '#3c3836', bg2 = '#504945', bg3 = '#665c54', bg4 = '#7c6f64',
  fg0 = '#fbf1c7', fg1 = '#ebdbb2', fg2 = '#d5c4a1', fg3 = '#bdae93', fg4 = '#a89984',
  red = '#ea6962',
  green = '#a9b665',
  yellow = '#d8a657',
  blue = '#7daea3',
  purple = '#d3869b',
  aqua = '#89b48c',
  orange = '#e78a4e',
  gray = '#928374',
}

colors = material
-- stylua: ignore end

local setup_groups = function()
  vim.g.terminal_color_0 = colors.bg0
  vim.g.terminal_color_8 = colors.gray
  vim.g.terminal_color_1 = colors.red
  vim.g.terminal_color_9 = colors.red
  vim.g.terminal_color_2 = colors.green
  vim.g.terminal_color_10 = colors.green
  vim.g.terminal_color_3 = colors.yellow
  vim.g.terminal_color_11 = colors.yellow
  vim.g.terminal_color_4 = colors.blue
  vim.g.terminal_color_12 = colors.blue
  vim.g.terminal_color_5 = colors.purple
  vim.g.terminal_color_13 = colors.purple
  vim.g.terminal_color_6 = colors.aqua
  vim.g.terminal_color_14 = colors.aqua
  vim.g.terminal_color_7 = colors.fg4
  vim.g.terminal_color_15 = colors.fg1

  return {
    -- Base groups
    GruvboxFg0 = { fg = colors.fg0 },
    GruvboxFg1 = { fg = colors.fg1 },
    GruvboxFg2 = { fg = colors.fg2 },
    GruvboxFg3 = { fg = colors.fg3 },
    GruvboxFg4 = { fg = colors.fg4 },
    GruvboxGray = { fg = colors.gray },
    GruvboxBg0 = { fg = colors.bg0 },
    GruvboxBg1 = { fg = colors.bg1 },
    GruvboxBg2 = { fg = colors.bg2 },
    GruvboxBg3 = { fg = colors.bg3 },
    GruvboxBg4 = { fg = colors.bg4 },
    GruvboxRed = { fg = colors.red },
    GruvboxRedBold = { fg = colors.red },
    GruvboxGreen = { fg = colors.green },
    GruvboxGreenBold = { fg = colors.green },
    GruvboxYellow = { fg = colors.yellow },
    GruvboxYellowBold = { fg = colors.yellow },
    GruvboxBlue = { fg = colors.blue },
    GruvboxBlueBold = { fg = colors.blue },
    GruvboxPurple = { fg = colors.purple },
    GruvboxPurpleBold = { fg = colors.purple },
    GruvboxAqua = { fg = colors.aqua },
    GruvboxAquaBold = { fg = colors.aqua },
    GruvboxOrange = { fg = colors.orange },
    GruvboxOrangeBold = { fg = colors.orange },
    GruvboxRedSign = { fg = colors.red },
    GruvboxYellowSign = { fg = colors.yellow },
    GruvboxBlueSign = { fg = colors.blue },
    GruvboxPurpleSign = { fg = colors.purple },
    GruvboxAquaSign = { fg = colors.aqua },
    GruvboxOrangeSign = { fg = colors.orange },
    GruvboxRedUnderline = { undercurl = true, sp = colors.red },
    GruvboxGreenUnderline = { undercurl = true, sp = colors.green },
    GruvboxYellowUnderline = { undercurl = true, sp = colors.yellow },
    GruvboxBlueUnderline = { undercurl = true, sp = colors.blue },
    GruvboxPurpleUnderline = { undercurl = true, sp = colors.purple },
    GruvboxAquaUnderline = { undercurl = true, sp = colors.aqua },
    GruvboxOrangeUnderline = { undercurl = true, sp = colors.orange },
    Normal = { fg = colors.fg1, bg = nil },
    NormalFloat = { fg = colors.fg1, bg = colors.bg1 },
    NormalNC = { link = 'Normal' },
    CursorLine = { bg = colors.bg1 },
    CursorColumn = { link = 'CursorLine' },
    TabLineFill = { fg = colors.bg4, bg = colors.bg1 },
    TabLineSel = { fg = colors.green, bg = colors.bg1 },
    TabLine = { link = 'TabLineFill' },
    MatchParen = { bg = colors.bg3 },
    ColorColumn = { bg = colors.bg1 },
    Conceal = { fg = colors.blue },
    CursorLineNr = { fg = colors.yellow, bg = colors.bg1 },
    NonText = { link = 'GruvboxBg2' },
    SpecialKey = { link = 'GruvboxFg4' },
    Visual = { bg = colors.bg3 },
    VisualNOS = { link = 'Visual' },
    Search = { fg = colors.yellow, bg = colors.bg0, reverse = true },
    IncSearch = { fg = colors.orange, bg = colors.bg0, reverse = true },
    CurSearch = { link = 'IncSearch' },
    QuickFixLine = { fg = colors.bg0, bg = colors.yellow },
    Underlined = { undercurl = true, fg = colors.blue },
    StatusLine = { fg = colors.bg2, bg = colors.fg1, reverse = true },
    StatusLineBranch = { fg = colors.bg2, bg = colors.fg3, reverse = true },
    StatusLineNC = { fg = colors.bg2, bg = colors.fg2, reverse = true },
    WinBar = { fg = colors.fg4, bg = colors.bg0 },
    WinBarNC = { fg = colors.fg3, bg = colors.bg1 },
    WinSeparator = { fg = colors.bg3, bg = nil },
    WildMenu = { fg = colors.blue, bg = colors.bg2 },
    Directory = { link = 'GruvboxBlueBold' },
    Title = { link = 'GruvboxGreenBold' },
    ErrorMsg = { fg = colors.bg0, bg = colors.red },
    MoreMsg = { link = 'GruvboxYellowBold' },
    ModeMsg = { link = 'GruvboxYellowBold' },
    Question = { link = 'GruvboxOrangeBold' },
    WarningMsg = { link = 'GruvboxRedBold' },
    LineNr = { fg = colors.bg4 },
    SignColumn = { bg = nil },
    Folded = { fg = colors.gray, bg = colors.bg1, italic = false },
    FoldColumn = { fg = colors.gray, bg = nil },
    Cursor = { reverse = true },
    vCursor = { link = 'Cursor' },
    iCursor = { link = 'Cursor' },
    lCursor = { link = 'Cursor' },
    Special = { link = 'GruvboxOrange' },
    Comment = { fg = colors.gray, italic = false },
    Todo = { fg = colors.fg0, italic = false },
    Done = { fg = colors.orange, italic = false },
    Error = { fg = colors.red, reverse = true },
    Statement = { link = 'GruvboxRed' },
    Conditional = { link = 'GruvboxRed' },
    Repeat = { link = 'GruvboxRed' },
    Label = { link = 'GruvboxRed' },
    Exception = { link = 'GruvboxRed' },
    Operator = { fg = colors.orange, italic = false },
    Keyword = { link = 'GruvboxRed' },
    Identifier = { link = 'Normal' },
    Function = { link = 'GruvboxGreenBold' },
    PreProc = { link = 'GruvboxAqua' },
    Include = { link = 'GruvboxAqua' },
    Define = { link = 'GruvboxAqua' },
    Macro = { link = 'GruvboxAqua' },
    PreCondit = { link = 'GruvboxAqua' },
    Constant = { link = 'GruvboxPurple' },
    Character = { link = 'GruvboxPurple' },
    String = { fg = colors.green, italic = false },
    Boolean = { link = 'GruvboxPurple' },
    Number = { link = 'GruvboxPurple' },
    Float = { link = 'GruvboxPurple' },
    Type = { link = 'GruvboxYellow' },
    StorageClass = { link = 'GruvboxOrange' },
    Structure = { link = 'GruvboxAqua' },
    Typedef = { link = 'GruvboxYellow' },
    Pmenu = { fg = colors.fg1, bg = colors.bg2 },
    PmenuSel = { fg = colors.bg2, bg = colors.blue },
    PmenuSbar = { bg = colors.bg2 },
    PmenuThumb = { bg = colors.bg4 },
    DiffDelete = { fg = colors.red, bg = colors.bg0, reverse = true },
    DiffAdd = { fg = colors.green, bg = colors.bg0, reverse = true },
    DiffChange = { fg = colors.aqua, bg = colors.bg0, reverse = true },
    DiffText = { fg = colors.yellow, bg = colors.bg0, reverse = true },
    SpellCap = { link = 'GruvboxBlueUnderline' },
    SpellBad = { link = 'GruvboxRedUnderline' },
    SpellLocal = { link = 'GruvboxAquaUnderline' },
    SpellRare = { link = 'GruvboxPurpleUnderline' },
    Whitespace = { fg = colors.bg2 },
    -- semantic token
    -- adapted from https://github.com/jdrouhard/neovim/blob/9f035559defd9d575f37fd825954610065d9cf96/src/nvim/highlight_group.c#L267
    ['@class'] = { link = '@constructor' },
    ['@decorator'] = { link = 'Identifier' },
    ['@enum'] = { link = '@constructor' },
    ['@enumMember'] = { link = 'Constant' },
    ['@event'] = { link = 'Identifier' },
    ['@interface'] = { link = 'Identifier' },
    ['@modifier'] = { link = 'Identifier' },
    ['@regexp'] = { link = 'SpecialChar' },
    ['@struct'] = { link = '@constructor' },
    ['@typeParameter'] = { link = 'Type' },
    -- nvim-treesitter (0.8 compat)
    -- Adapted from https://github.com/nvim-treesitter/nvim-treesitter/commit/42ab95d5e11f247c6f0c8f5181b02e816caa4a4f#commitcomment-87014462
    ['@annotation'] = { link = 'Operator' },
    ['@comment'] = { link = 'Comment' },
    ['@none'] = { bg = 'NONE', fg = 'NONE' },
    ['@preproc'] = { link = 'PreProc' },
    ['@define'] = { link = 'Define' },
    ['@operator'] = { link = 'Operator' },
    ['@punctuation.delimiter'] = { link = 'Delimiter' },
    ['@punctuation.bracket'] = { link = 'Delimiter' },
    ['@punctuation.special'] = { link = 'Delimiter' },
    ['@string'] = { link = 'String' },
    ['@string.regex'] = { link = 'String' },
    ['@string.escape'] = { link = 'SpecialChar' },
    ['@string.special'] = { link = 'SpecialChar' },
    ['@character'] = { link = 'Character' },
    ['@character.special'] = { link = 'SpecialChar' },
    ['@boolean'] = { link = 'Boolean' },
    ['@number'] = { link = 'Number' },
    ['@float'] = { link = 'Float' },
    ['@function'] = { link = 'Function' },
    ['@function.call'] = { link = 'Function' },
    ['@function.builtin'] = { link = 'Special' },
    ['@function.macro'] = { link = 'Macro' },
    ['@method'] = { link = 'Function' },
    ['@method.call'] = { link = 'Function' },
    ['@constructor'] = { link = 'Special' },
    ['@parameter'] = { link = 'Identifier' },
    ['@keyword'] = { link = 'Keyword' },
    ['@keyword.function'] = { link = 'Keyword' },
    ['@keyword.return'] = { link = 'Keyword' },
    ['@conditional'] = { link = 'Conditional' },
    ['@repeat'] = { link = 'Repeat' },
    ['@debug'] = { link = 'Debug' },
    ['@label'] = { link = 'Label' },
    ['@include'] = { link = 'Include' },
    ['@exception'] = { link = 'Exception' },
    ['@type'] = { link = 'Type' },
    ['@type.builtin'] = { link = 'Type' },
    ['@type.qualifier'] = { link = 'Type' },
    ['@type.definition'] = { link = 'Typedef' },
    ['@storageclass'] = { link = 'StorageClass' },
    ['@attribute'] = { link = 'PreProc' },
    ['@field'] = { link = 'Identifier' },
    ['@property'] = { link = 'Identifier' },
    ['@variable'] = { link = 'GruvboxFg1' },
    ['@variable.builtin'] = { link = 'Special' },
    ['@constant'] = { link = 'Constant' },
    ['@constant.builtin'] = { link = 'Special' },
    ['@constant.macro'] = { link = 'Define' },
    ['@namespace'] = { link = 'GruvboxFg1' },
    ['@symbol'] = { link = 'Identifier' },
    ['@text'] = { link = 'GruvboxFg1' },
    ['@text.title'] = { link = 'Title' },
    ['@text.literal'] = { link = 'String' },
    ['@text.uri'] = { link = 'Underlined' },
    ['@text.math'] = { link = 'Special' },
    ['@text.environment'] = { link = 'Macro' },
    ['@text.environment.name'] = { link = 'Type' },
    ['@text.reference'] = { link = 'Constant' },
    ['@text.todo'] = { link = 'Todo' },
    ['@text.todo.unchecked'] = { link = 'Todo' },
    ['@text.todo.checked'] = { link = 'Done' },
    ['@text.note'] = { link = 'SpecialComment' },
    ['@text.warning'] = { link = 'WarningMsg' },
    ['@text.danger'] = { link = 'ErrorMsg' },
    ['@text.diff.add'] = { link = 'diffAdded' },
    ['@text.diff.delete'] = { link = 'diffRemoved' },
    ['@tag'] = { link = 'Tag' },
    ['@tag.attribute'] = { link = 'Identifier' },
    ['@tag.delimiter'] = { link = 'Delimiter' },

    -- nvim-treesitter (0.8 overrides)
    ['@text.strong'] = { bold = false },
    ['@text.strike'] = { strikethrough = false },
    ['@text.emphasis'] = { italic = false },
    ['@text.underline'] = { underline = false },
    ['@keyword.operator'] = { link = 'GruvboxRed' },

    -- telescope.nvim
    TelescopeNormal = { link = 'GruvboxFg1' },
    TelescopeSelection = { link = 'Pmenu' },
    TelescopeSelectionCaret = { link = 'GruvboxRed' },
    TelescopeMultiSelection = { link = 'GruvboxGray' },
    TelescopeBorder = { link = 'GruvboxFg1' },
    TelescopeMatching = { link = 'GruvboxOrange' },
    TelescopePromptPrefix = { link = 'GruvboxBlue' },
    TelescopePrompt = { link = 'TelescopeNormal' },
    TelescopeCustomBorder = { link = 'GruvboxBg3' },
    TelescopeResultsBorder = { link = 'TelescopeCustomBorder' },
    TelescopePreviewBorder = { link = 'TelescopeCustomBorder' },
    TelescopePromptBorder = { link = 'TelescopeCustomBorder' },
    TelescopePromptCounter = { link = 'TelescopeCustomBorder' },

    -- nvim-cmp
    CmpItemAbbrMatchFuzzy = { link = 'GruvboxBlueUnderline' },
    CmpItemMenu = { link = 'GruvboxGray' },
    CmpItemKindText = { link = 'GruvboxOrange' },
    CmpItemKindVariable = { link = 'GruvboxOrange' },
    CmpItemKindMethod = { link = 'GruvboxOrange' },
    CmpItemKindFunction = { link = 'GruvboxOrange' },
    CmpItemKindConstructor = { link = 'GruvboxOrange' },
    CmpItemKindUnit = { link = 'GruvboxOrange' },
    CmpItemKindField = { link = 'GruvboxOrange' },
    CmpItemKindClass = { link = 'GruvboxOrange' },
    CmpItemKindInterface = { link = 'GruvboxOrange' },
    CmpItemKindModule = { link = 'GruvboxOrange' },
    CmpItemKindProperty = { link = 'GruvboxOrange' },
    CmpItemKindValue = { link = 'GruvboxOrange' },
    CmpItemKindEnum = { link = 'GruvboxOrange' },
    CmpItemKindOperator = { link = 'GruvboxOrange' },
    CmpItemKindKeyword = { link = 'GruvboxOrange' },
    CmpItemKindEvent = { link = 'GruvboxOrange' },
    CmpItemKindReference = { link = 'GruvboxOrange' },
    CmpItemKindColor = { link = 'GruvboxOrange' },
    CmpItemKindSnippet = { link = 'GruvboxOrange' },
    CmpItemKindFile = { link = 'GruvboxGreen' },
    CmpItemKindFolder = { link = 'GruvboxGreen' },
    CmpItemKindEnumMember = { link = 'GruvboxOrange' },
    CmpItemKindConstant = { link = 'GruvboxOrange' },
    CmpItemKindStruct = { link = 'GruvboxOrange' },
    CmpItemKindTypeParameter = { link = 'GruvboxOrange' },
    diffAdded = { link = 'GruvboxGreen' },
    diffRemoved = { link = 'GruvboxRed' },
    diffChanged = { link = 'GruvboxAqua' },
    diffFile = { link = 'GruvboxOrange' },
    diffNewFile = { link = 'GruvboxYellow' },
    diffOldFile = { link = 'GruvboxOrange' },
    diffLine = { link = 'GruvboxBlue' },
    diffIndexLine = { link = 'diffChanged' },

    -- LSP Diagnostic
    DiagnosticError = { link = 'GruvboxRed' },
    DiagnosticSignError = { link = 'GruvboxRedSign' },
    DiagnosticUnderlineError = { link = 'GruvboxRedUnderline' },
    DiagnosticVirtualTextError = { link = 'GruvboxRed' },
    DiagnosticFloatingError = { link = 'GruvboxRed' },

    DiagnosticWarn = { link = 'GruvboxYellow' },
    DiagnosticSignWarn = { link = 'GruvboxYellowSign' },
    DiagnosticUnderlineWarn = { link = 'GruvboxYellowUnderline' },
    DiagnosticVirtualTextWarn = { link = 'GruvboxYellow' },
    DiagnosticFloatingWarn = { link = 'GruvboxYellow' },

    DiagnosticInfo = { link = 'GruvboxBlue' },
    DiagnosticSignInfo = { link = 'GruvboxBlueSign' },
    DiagnosticUnderlineInfo = { link = 'GruvboxBlueUnderline' },
    DiagnosticVirtualTextInfo = { link = 'GruvboxBlue' },
    DiagnosticFloatingInfo = { link = 'GruvboxBlue' },

    DiagnosticHint = { link = 'GruvboxOrange' },
    DiagnosticSignHint = { link = 'GruvboxOrangeSign' },
    DiagnosticUnderlineHint = { link = 'GruvboxOrangeUnderline' },
    DiagnosticVirtualTextHint = { link = 'GruvboxOrange' },
    DiagnosticFloatingHint = { link = 'GruvboxOrange' },

    -- custom
    rustCommentLineDoc = { link = 'Comment' },
    HarpoonWindow = { link = 'Normal' },
    HarpoonBorder = { link = 'GruvboxFg2' },
  }
end

M.load = function()
  if vim.version().minor < 8 then
    return vim.notify_once('[gruvbox] needs nvim ≥0.8')
  end
  vim.cmd.hi('clear')
  vim.g.colors_name, vim.o.termguicolors = 'gruvbox', true
  for group, opts in pairs(setup_groups()) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return M
