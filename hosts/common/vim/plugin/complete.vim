" complete.vim — insert-mode completion, part of the dotfiles' vimrc (follows
" its style guide). Completions pop up while typing on builds that have
" 'autocomplete' (a later 9.1 patch); elsewhere <C-n> or <C-Space> opens the
" menu. Sources are the open buffers and file paths.
"
" Keys mirror blink.cmp in the Neovim config where Vim allows: <C-n>/<C-p>
" or <Down>/<Up> select, <CR> accepts the selected item, <C-e> closes the
" menu and <C-Space> opens it. Nothing is preselected: with 'autocomplete'
" on, Vim ignores "noinsert", so <CR> with no selection is a plain newline.
scriptencoding utf-8
if exists('g:loaded_dotfiles_complete')
  finish
endif
let g:loaded_dotfiles_complete = 1



" Options ----------------------------------------------------------------------
" No "popup"/"preview": extra info about an item is simply not shown
set completeopt=menuone,noselect
set pumheight=10
" Buffers only; tags and included files are slow to scan while typing
set complete=.,w,b,u

" Values that only later 9.1 patches accept (exists() can't test for these)
for s:value in ['completeopt+=fuzzy', 'complete+=FCompletePath']
  try
    execute 'set' s:value
  catch /^Vim\%((\a\+)\)\=:E47[45]:/
  endtry
endfor

if exists('+autocomplete')
  set autocomplete
  " Not in CSS, where the list is mostly noise (as in the Neovim config).
  " 'autocomplete' is global, so it is switched as buffers are entered.
  augroup dotfiles_complete
    autocmd!
    autocmd BufEnter,FileType * let &autocomplete =
          \ index(['css', 'scss', 'less'], &filetype) < 0
  augroup END
endif



" Paths ------------------------------------------------------------------------
" A 'complete' source: file names after a '/' (relative to the working
" directory, '~' and absolute paths work too). Completes one path component
" at a time; directories end in '/'.
function! CompletePath(findstart, base) abort
  if a:findstart
    let path = matchstr(strpart(getline('.'), 0, col('.') - 1), '\f\+$')
    let s:dir = matchstr(path, '^.*/')
    return col('.') - 1 - (len(path) - len(s:dir))
  endif
  if s:dir ==# ''
    return []
  endif
  let items = []
  for f in getcompletion(s:dir . a:base, 'file')
    let name = fnamemodify(substitute(f, '/$', '', ''), ':t')
    let isdir = f =~# '/$'
    call add(items, {'word': name . (isdir ? '/' : ''), 'menu': '[path]',
          \ 'kind': isdir ? 'd' : 'f'})
  endfor
  return items
endfunction



" Keymaps ----------------------------------------------------------------------
" Accept the selected item. With the menu open and nothing selected, Vim's
" own <CR> only closes the menu, so close it first to get the newline.
inoremap <expr> <CR> !pumvisible() ? '<CR>'
      \ : complete_info(['selected']).selected >= 0 ? '<C-y>' : '<C-e><CR>'
" Terminals send <C-Space> as <Nul>
inoremap <expr> <C-Space> pumvisible() ? '<C-e>' : '<C-n>'
inoremap <expr> <Nul> pumvisible() ? '<C-e>' : '<C-n>'
