local M = {}
local fmt = {
  set = function(cmd, val)
    local fmt = '\\let\\TMP%s\\%s\\def\\%s%s'
    return fmt:format(cmd, cmd, cmd, val)
  end,
  unset = function(cmd) return ('\\let\\%s\\TMP%s'):format(cmd, cmd) end,
}

---@param line string
---@return string
M.transform = function(line)
  line = vim.fn.trim(line)
  if not (line:byte(1) == 37 and line:byte(2) == 37) then return line end
  local parts, i, buffer = vim.fn.split(line, ' '), 1, {}
  while i <= #parts do
    if i <= #parts - 2 and parts[i] == 'set' then
      table.insert(buffer, fmt.set(parts[i + 1], parts[i + 2]))
      i = i + 3
    elseif parts[i] == 'unset' then
      i = i + 1
      while i <= #parts do
        table.insert(buffer, fmt.unset(parts[i]))
        i = i + 1
      end
      break
    else
      i = i + 1
    end
  end
  return table.concat(buffer, ' ')
end

--- @return boolean, string[]
local function pdflatex(doc)
  vim.fn.delete('.build/tmp', 'rf')
  vim.fn.mkdir('.build', 'p')
  local args = {
    'pdflatex',
    '--halt-on-error',
    '--output-directory=.build',
    '--jobname',
    vim.fn.expand('%:t:r'),
  }
  local cmd = table.concat(args, ' ') .. '>.build/tmp;echo $?>.build/status'
  local handle = io.popen(cmd, 'w')
  if handle ~= nil then
    local transform = require('brew.latex').transform
    for _, v in pairs(doc) do
      handle:write(transform(v) .. '\n')
    end
    handle:flush()
    handle:close()
    local ok = vim.fn.readfile('.build/status')[1] == '0'
    local output = ok and {} or vim.fn.readfile('.build/tmp')
    return ok, output
  end
  return false, {}
end

M.entry = function()
  local buffer = vim.fn.getline(1, '$')
  local success, output = pdflatex(buffer)
  vim.cmd('redraw')
  if not success then
    print('[pdflatex] build failed.')
    local qf = {}
    for _, v in pairs(output) do
      table.insert(qf, { text = v })
    end
    vim.fn.setqflist(qf)
  else
    print('[pdflatex] build successful!')
  end
end

return M

-- USAGE
-- autocmd({ 'BufWritePost' }, {
--   pattern = { '*.tex' },
--   callback = function() require('brew.latex').entry() end,
-- })
