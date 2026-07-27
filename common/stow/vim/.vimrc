filetype plugin indent on
syntax enable

let mapleader = " "

set number
set relativenumber
set colorcolumn=80

set expandtab
set shiftwidth=2
set tabstop=2
set smartindent

set ignorecase
set smartcase
set hlsearch

set splitbelow
set splitright
set scrolloff=4
set clipboard=unnamedplus

if has('termguicolors')
  set termguicolors
endif

nnoremap <silent> <Esc> :nohlsearch<CR>
nnoremap <leader>y "+y
xnoremap <leader>y "+y
