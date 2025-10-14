if vim.version().minor == 11 then
  require('brew.init_11')
else
  require('brew.init_9')
end
