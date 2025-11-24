-- All configurations have been moved into `./lua/brew` so that LuaLS can work
-- properly. See
--  * https://github.com/neovim/nvim-lspconfig/blob/30a2b191bc/doc/configs.md#lua_ls
--  * https://github.com/neovim/nvim-lspconfig/issues/3189
--  * https://github.com/LuaLS/lua-language-server/issues/2061
--
-- But apparently this does not fix the issue. Darn.
require('brew')
