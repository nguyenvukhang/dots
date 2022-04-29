local builtin = require('telescope.builtin')
local file = require('brew.telescope.file')
local word = require('brew.telescope.word')
local sessions = require('brew.telescope.sessions')

-- custom set keymap for telescope to shorten rhs
local nnoremap = function(keypress, callback)
    vim.api.nvim_set_keymap(
        "n",
        keypress,
        "",
        { noremap = true, silent = true, callback = callback }
    )
end

nnoremap("<c-b>", builtin.buffers)

-- file search
nnoremap("<c-p>", file.repo)
nnoremap("<c-f>", file.cwd)

-- word search
nnoremap("<leader>ps", word.repo)
nnoremap("<leader>pw", word.cwd)
nnoremap("<leader>pf", word.this_in_repo)

-- search dots
nnoremap("<leader>sd", file.dots)

-- search university
nnoremap("<leader>su", file.university)

-- search notes
nnoremap("<leader>sn", file.notes)

-- search telescope
nnoremap("<leader>st", file.telescope)

-- search past-open files (recents)
nnoremap("<leader>sp", file.oldfiles)

-- search repos
nnoremap("<leader>sr", file.repo_search)
nnoremap("<leader>so", file.other_repos_search)

-- search vim help
nnoremap("<leader>sh", builtin.help_tags)

-- search manpages
nnoremap("<leader>sm", builtin.man_pages)

-- session
nnoremap("<c-s>", sessions.save_session)
nnoremap("<leader>rs", sessions.sessions) -- restore session

-- git stuff
nnoremap("<leader>gs", builtin.git_status)
