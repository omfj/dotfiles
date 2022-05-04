call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'luochen1990/rainbow'
Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
Plug 'preservim/nerdtree'
Plug 'nanotech/jellybeans.vim'
Plug 'tomasr/molokai'
Plug 'tpope/vim-commentary'
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
Plug 'ntpeters/vim-better-whitespace'
Plug 'mattn/emmet-vim'
Plug 'leafgarland/typescript-vim'
Plug 'valloric/youcompleteme'
Plug 'w0rp/ale'
Plug 'ap/vim-css-color'
Plug 'tpope/vim-sensible'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'tpope/vim-sleuth'
Plug 'rust-lang/rust.vim'
call plug#end()

" Vim
let mapleader = " "
colorscheme jellybeans
set backspace=indent,eol,start
set nu rnu
set so=8

" Prettier
filetype plugin indent on
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

" Whitespace highlight
let g:better_whitespace_enabled=1

" Color brackets
let g:rainbow_active = 1

" Prettier
nmap <Leader>py <Plug>(Prettier)

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#enable#fugitive=1
let g:airline#enable#syntastic=1
let g:airline#enable#bufferline=1

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

""" Notes
" gc - comment out line in visual mode
