--
-- https://github.com/SirVer/ultisnips
--

local conf = require('brew.core').env.conf

-- commit to using $0 snippets
vim.g.UltiSnipsExpandTrigger       = '<Tab>'
vim.g.UltiSnipsEditSplit           = 'vertical'
vim.g.UltiSnipsSnippetDirectories  = { conf..'/ultisnips' }

-- abbreviations
vim.cmd('cnoreabbrev ue UltiSnipsEdit')
