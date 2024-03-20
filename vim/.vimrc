set nocompatible
set backspace=indent,eol,start
set complete-=i
set smarttab
set nrformats-=octal
set ttimeout
set ttimeoutlen=100
set incsearch
set hlsearch
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
set laststatus=2
set number
set relativenumber
set ruler
set wildmenu
set scrolloff=1
set sidescroll=1
set sidescrolloff=2
set display+=lastline,truncate
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set formatoptions+=j
set autoread
set history=1000
set tabpagemax=50
set viminfo^=!
set sessionoptions-=options
set viewoptions-=options

if &t_Co == 8
  set t_Co=16
endif

if &shell =~# 'fish$'
  set shell=/usr/bin/env\ bash
endif

set nolangremap
filetype plugin indent on

if !exists('g:syntax_on')
  syntax enable
endif

inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

let g:is_posix = 1

if findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

if &filetype !=? 'man' && !has('nvim')
  runtime ftplugin/man.vim
endif

