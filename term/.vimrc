let mapleader = " "

filetype plugin indent on
syntax on

runtime macros/matchit.vim

set autoindent
set backspace=indent,eol,start
set expandtab
set hidden
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:»·,trail:·,extends:>,precedes:<,nbsp:␣
set number
set path+=**
set relativenumber
set ruler
set shiftround
set shiftwidth=4
set smartcase
set softtabstop=4
set tabstop=4
set wildmenu

inoremap <C-C> <ESC>

nnoremap n nzz
nnoremap N Nzz

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p

color elflord
