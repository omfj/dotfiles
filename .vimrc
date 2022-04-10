call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'ervandew/supertab'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nanotech/jellybeans.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lervag/vimtex'
Plug 'vim-python/python-syntax'
Plug 'jiangmiao/auto-pairs'
call plug#end()

" Etc
let mapleader = " "
set nu rnu
set encoding=utf-8
set scrolloff=7

" Tab to spaces
set tabstop=4
set shiftwidth=4
set expandtab

" General colors
let &t_ut=''
let g:python_highlight_all = 1
colorscheme jellybeans

" Vim airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'

" Vimtex
filetype plugin indent on
syntax enable
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexrun'
let maplocalleader = " "
