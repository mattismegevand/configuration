let mapleader = " "
let g:netrw_banner = 0

set guicursor=

set number
set relativenumber
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set ignorecase
set smartcase
set nowrap
set scrolloff=8
set colorcolumn=80
set list
set listchars=tab:»\ ,trail:·,nbsp:␣

inoremap <C-c> <Esc>

nnoremap <leader>fv :Ex<CR>
nnoremap <leader>/ :nohlsearch<CR>
nnoremap <leader>bg :exec &background=="light"? "set background=dark" : "set background=light"<CR>
nnoremap <C-j> :cn<CR>zzzv
nnoremap <C-k> :cp<CR>zzzv
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-]> <C-]>zzzv
nnoremap <C-o> <C-o>zzzv
nnoremap <C-i> <C-i>zzzv
nnoremap <leader>p "+p
nnoremap <leader>P "+P
nnoremap <leader>y "+y
nnoremap <leader>Y "+y$

vnoremap <leader>p "+p
vnoremap <leader>P "+P
vnoremap <leader>y "+y
