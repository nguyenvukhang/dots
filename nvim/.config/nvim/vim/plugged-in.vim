call plug#begin('~/.config/nvim/plugged')

" sparklez
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }

" markdown goodness
Plug 'godlygeek/tabular'

" T-POPE
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

" math & notes
Plug 'vimplug/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'lervag/vimtex'

" TEEJ
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" native LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" for nvim-cmp to work with ultisnips
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

" old but gold
Plug 'rmagatti/alternate-toggler'
" Plug 'jiangmiao/auto-pairs'

" statusline
Plug 'nvim-lualine/lualine.nvim'

" comments
Plug 'terrortylor/nvim-comment'

" colorizer
Plug 'vimplug/nvim-colorizer.lua'

" old friends
" Plug 'lifepillar/vim-colortemplate'

call plug#end()
