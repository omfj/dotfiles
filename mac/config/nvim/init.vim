call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chun-yang/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'nanotech/jellybeans.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'luochen1990/rainbow'
Plug 'ntpeters/vim-better-whitespace'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'
Plug 'tomasr/molokai'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
call plug#end()

let mapleader = " "
colo base16-default-dark
set termguicolors
set backspace=indent,eol,start
set nu rnu
set so=8

" Bracker pair color
let g:rainbow_active = 1

" Nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Window Navigation with Ctrl-[hjkl]
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-H> <C-W>h
noremap <C-L> <C-W>l

" Coc-prettier
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
