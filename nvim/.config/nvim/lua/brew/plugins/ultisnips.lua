--
-- https://github.com/SirVer/ultisnips
--

local conf = require('brew.core').env.conf

vim.g.UltiSnipsExpandTrigger       = '<Tab>'
vim.g.UltiSnipsJumpForwardTrigger  = '<C-l>'
vim.g.UltiSnipsJumpBackwardTrigger = '<C-h>'
vim.g.UltiSnipsEditSplit           = 'vertical'
vim.g.UltiSnipsSnippetDirectories  = { conf..'/ultisnips' }

-- abbreviations
vim.cmd('cnoreabbrev ue UltiSnipsEdit')
