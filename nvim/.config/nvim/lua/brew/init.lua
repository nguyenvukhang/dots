local f = vim.fn

-- to clear command line area:
-- vim.cmd('redraw!')

M = {}
local utils = {}
local env = {}
local functions = {}

-- merges source into target
-- (source overwrites target)
utils.assign = function(target, source)
  if (source) then
    for k,s in pairs(source) do target[k] = s end
  end
end

utils.qflist_is_open = function()
  if next(f.filter(f.getwininfo(), 'v:val.quickfix')) == nil then
    return false
  else
    return true
  end
end

utils.loclist_is_open = function()
  local next = next
  if next(f.filter(f.getwininfo(), 'v:val.loclist')) == nil then
    return false
  else
    return true
  end
end

utils.is_git_repo = function ()
  local git_check = vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1]
  if git_check == "true" then
    return true
  else
    return false
  end
end

env.home = vim.env.HOME..'/'
env.conf = env.home..'.config/nvim/'
env.repos = env.home..'repos/'
env.dots_root = vim.env.DOTS..'/'
env.dots = {
  env.dots_root,
  env.dots_root.."nvim/.config/nvim",
  env.dots_root.."zsh",
  env.dots_root.."personal",
}

-- quick hack to toggle quickfix
functions.ToggleQuickFix = function()
  if utils.qflist_is_open() then
    vim.api.nvim_command('cclose')
  else
    vim.api.nvim_command('botright copen')
  end
end

-- quick hack to toggle local list
functions.ToggleLocalList = function()
  if not pcall(function ()
    if utils.loclist_is_open() then
      vim.api.nvim_command('lclose')
    else
      vim.api.nvim_command('botright lopen')
    end
  end) then
    print('local list doesn\'t exist')
  end
end

-- opens NERDTree right here where you are
functions.NERDTreeHere = function()
  local here = vim.fn.getcwd()
  vim.cmd('NERDTreeToggle '..here)
end

-- makes a split if there's only one window, when using <Leader>h/l
functions.SplitJump = function(direction)
  local w = vim.fn.getwininfo()
  if #w == 1 then vim.api.nvim_command('vs')
    if direction == 'l' then vim.api.nvim_command('wincmd l') end
  else
    vim.api.nvim_command('wincmd '..direction)
  end
end

-- toggles a todo
functions.Todolist = function()
  local opts = {
    dir  = env.home.."repos/uni/nightly/",
    file = "todo.md",
    ratio = 0.5,
  }
  local todoPath = opts.dir..opts.file
  local open = vim.fn.bufwinid(todoPath)
  if open < 0 then
    local h = math.floor(vim.fn.winheight(0) * opts.ratio)
    vim.cmd(h..'sp '..todoPath)
  else
    vim.cmd('bd '..todoPath)
  end
end

functions.DevelopmentTest = function ()
  local p = function(x)
    print(vim.inspect(x))
  end
  local listed = vim.fn.getbufinfo()
  p(listed.name)
end

M.functions = functions
M.env = env
M.utils = utils

-- gruvbox: the best color scheme of all time
M.colors = {
  black        = '#282828',
  white        = '#ebdbb2',
  red          = '#fb4934',
  green        = '#b8bb26',
  blue         = '#83a598',
  yellow       = '#fabd2f',
  gray         = '#928374',
  bg1          = "#3c3836",
  bg2          = "#504945",
  bg3          = "#665c54",
  bg4          = "#7c6f64",
  fg4          = "#a89984",
  fg3          = "#bdae93",
  fg2          = "#d5c4a1",
  fg1          = "#ebdbb2",
  fg0          = "#f9f5d7",
  lightgray    = '#504945',
  inactivegray = '#7c6f64',
  orange       = '#fe8019',
}

return M
