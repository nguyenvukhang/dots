--
-- https://github.com/iamcco/markdown-preview.nvim
--
local conf = require('brew').env.conf

vim.g.mkdp_auto_close = 0
vim.g.mkdp_preview_options = {
  katex = {
    macros = {
      ['\\d'] = '\\mathrm{d}',
      ['\\R'] = '\\mathbb{R}',
      ['\\Q'] = '\\mathbb{Q}',
      ['\\Z'] = '\\mathbb{Z}',
      ['\\C'] = '\\mathbb{C}',
      ['\\v'] = '\\bm',
      ['\\implies'] = '\\Rightarrow',
      ['\\rref'] = '\\text{rref}',
      ['\\colspace'] = '\\text{column space}',
      ['\\nullspace'] = '\\text{nullspace}',
      ['\\rank'] = '\\text{rank}',
      ['\\nullity'] = '\\text{nullity}',
      ['\\inverse'] = '^{-1}',
      ['\\f'] = '\\tfrac',
      ['\\df'] = '\\dfrac',
      ['\\GE'] = '\\xrightarrow{\\text{GE}}',
      ['\\GJE'] = '\\xrightarrow{\\text{GJE}}',
    },
  },
  disable_sync_scroll = false,
  disable_filename = 1,
}
vim.g.mkdp_markdown_css = conf..'data/github-markdown.css'

local abbrevs = function()
  local v = vim.api.nvim_command
  v('cnoreabbrev MP MarkdownPreview')
  v('cnoreabbrev MS MarkdownPreviewStop')
end

abbrevs()
