" rg.vim — ripgrep integration, part of the dotfiles' vimrc (follows its
" style guide). :grep runs rg, and :find/:sfind/:tabfind complete from
" `rg --files`. (<leader>sg, which starts a :grep, is in the vimrc: it
" works without ripgrep too.)
scriptencoding utf-8
if exists('g:loaded_dotfiles_rg') || !executable('rg')
  finish
endif
let g:loaded_dotfiles_rg = 1

" Native Windows rg prints 'dir\file' paths, which Git Bash's Vim can't open
let s:rg = 'rg' . (has('win32unix') ? ' --path-separator /' : '')



" :grep ------------------------------------------------------------------------
let &grepprg = s:rg . ' --vimgrep --smart-case'
set grepformat=%f:%l:%c:%m



" :find ------------------------------------------------------------------------
" With ripgrep, :find/:sfind/:tabfind complete from `rg --files` (respects
" .gitignore) filtered by Vim's own fuzzy matcher. Cached per command line.
" Needs 'findfunc' (a later 9.1 patch).
if exists('+findfunc')
  let s:rg_files = []
  function! RgFind(arg, cmdcomplete) abort
    if empty(s:rg_files)
      let s:rg_files = systemlist(s:rg . ' --files --hidden --glob '
            \ . shellescape('!.git'))
    endif
    return empty(a:arg) ? s:rg_files : matchfuzzy(s:rg_files, a:arg)
  endfunction
  set findfunc=RgFind
  augroup dotfiles_rg_find
    autocmd!
    autocmd CmdlineEnter : let s:rg_files = []
  augroup END
endif
