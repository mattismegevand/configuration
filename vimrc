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
set hlsearch
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
set scrolloff=3
set sidescrolloff=5
set mouse=a
set noerrorbells
set visualbell
set timeoutlen=500
set ttimeoutlen=10
set undofile
set undodir=~/.vim/undo
if !isdirectory(expand(&undodir))
  call mkdir(expand(&undodir), "p", 0700)
endif

inoremap <C-C> <ESC>

nnoremap n nzz
nnoremap N Nzz

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p
nnoremap <leader><space> :nohlsearch<CR>

try
  colorscheme elflord
catch
  colorscheme desert
endtry
