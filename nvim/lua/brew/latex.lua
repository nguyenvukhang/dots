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

return M
