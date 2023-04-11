-- list of languages that use treesitter for syntax highlighting
local treesitter_list = { 'astro', 'markdown', 'latex' }

local treesitter = function()
  require('nvim-treesitter.configs').setup {
    highlight = {
      enable = true,
      -- restrict treesitter to just the `treesitter_list`
      disable = function(lang, _)
        -- print(not vim.tbl_contains(treesitter_list, lang))
        return not vim.tbl_contains(treesitter_list, lang)
      end,
      additional_vim_regex_highlighting = false,
    },
    ensure_installed = {
      'help',
      'javascript',
      'typescript',
      'c',
      'lua',
      'rust',
      'astro',
      'java',
      'latex',
      'markdown',
      'markdown_inline',
      'python',
    },
  }
end

treesitter()
