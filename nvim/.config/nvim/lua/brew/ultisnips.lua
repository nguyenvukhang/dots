--
-- https://github.com/SirVer/ultisnips
--

local conf = require('brew').env.conf

vim.g.UltiSnipsExpandTrigger       = '<Tab>'
vim.g.UltiSnipsJumpForwardTrigger  = ';'
vim.g.UltiSnipsJumpBackwardTrigger = ':'
vim.g.UltiSnipsEditSplit           = 'vertical'
vim.g.UltiSnipsSnippetDirectories  = { conf..'ultisnips' }

local abbrevs = function()
  local v = vim.api.nvim_command
  v('cnoreabbrev ue UltiSnipsEdit')
end

abbrevs()
