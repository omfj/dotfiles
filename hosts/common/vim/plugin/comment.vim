" comment.vim — gc commenting, part of the dotfiles' vimrc (follows its style
" guide). Loads Vim's comment package where the build ships it (later 9.1
" patches), and otherwise defines a stand-in: gc{motion}, gcc (with count) and
" visual gc toggle comments using 'commentstring'. If every non-blank line is
" commented they are uncommented.
scriptencoding utf-8
if exists('g:loaded_dotfiles_comment')
  finish
endif
let g:loaded_dotfiles_comment = 1

if !empty(globpath(&packpath, 'pack/*/opt/comment', 1))
  packadd comment
  finish
endif

function! CommentOperator(type, ...) abort
  let [l1, l2] = a:0 ? [line("'<"), line("'>")] : [line("'["), line("']")]
  let parts = split(&commentstring =~# '%s' ? &commentstring : '# %s',
        \ '%s', 1)
  let pre = substitute(parts[0], '\s*$', '', '')
  let post = substitute(get(parts, 1, ''), '^\s*', '', '')
  let rx = '\V\^\(\s\*\)' . escape(pre, '\') . ' \?\(\.\{-}\)'
        \ . (empty(post) ? '' : ' \?' . escape(post, '\')) . '\$'
  let lines = getline(l1, l2)
  let code = filter(copy(lines), {_, l -> l =~# '\S'})
  if empty(code)
    return
  endif
  if empty(filter(copy(code), {_, l -> l !~# rx}))
    call map(lines, {_, l -> l =~# rx ? substitute(l, rx, '\1\2', '') : l})
  else
    let ind = min(map(copy(code), {_, l -> match(l, '\S')}))
    call map(lines, {_, l -> l !~# '\S' ? l : strpart(l, 0, ind) . pre
          \ . ' ' . strpart(l, ind) . (empty(post) ? '' : ' ' . post)})
  endif
  call setline(l1, lines)
endfunction

function! s:CommentOp() abort
  set operatorfunc=CommentOperator
  return 'g@'
endfunction
nnoremap <expr> gc <SID>CommentOp()
nnoremap <expr> gcc <SID>CommentOp() . '_'
xnoremap <silent> gc :<C-u>call CommentOperator(visualmode(), 1)<CR>
