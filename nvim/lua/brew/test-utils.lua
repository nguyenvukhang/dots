local M = {}
M.log = true
M.tmp_dir = os.tmpname()

M.setup = function()
  os.remove(M.tmp_dir)
  os.execute('mkdir ' .. M.tmp_dir)
end

M.run = function(x)
  local cmd = 'cd ' .. M.tmp_dir .. ' && ' .. x
  if M.log then print('[' .. cmd .. ']') end
  return vim.fn.systemlist(cmd)
end

M.ls = function(dir)
  local ls = M.run('exa --all --tree ' .. (dir or ''))
  for i = 1, #ls do
    print(ls[i])
  end
end

M.print = function(x) print(vim.inspect(x)) end

M.iterprint = function(x)
  for i = 1, #x do
    M.print(x[i])
  end
end

M.assert_eq = function(received, expected)
  if received == expected then return end
  print(' ')
  print('received', vim.inspect(received))
  print('expected', vim.inspect(expected))
  print(' ')
  M.teardown()
  error('Assertion Error')
end

M.teardown = function() os.execute('rm -rf ' .. M.tmp_dir) end

return M
