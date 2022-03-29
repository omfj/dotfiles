call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'https://github.com/junegunn/vim-github-dashboard.git'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'preservim/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'valloric/youcompleteme'
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nanotech/jellybeans.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lervag/vimtex'
Plug 'vim-python/python-syntax'
call plug#end()

" Etc
let mapleader = " "
set nu rnu
set encoding=utf-8
set tabstop=4
set scrolloff=7

" General colors
let &t_ut=''
let g:python_highlight_all = 1
colorscheme jellybeans

" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

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
