" fzf.vim — fzf pickers without the fzf.vim plugin, part of the dotfiles'
" vimrc (follows its style guide). Adds :Files, :Buffers, :Recent and :Grep
" and their keymaps; without fzf they fall back to Vim's built-ins.
scriptencoding utf-8
if exists('g:loaded_dotfiles_fzf')
  finish
endif
let g:loaded_dotfiles_fzf = 1

" Native Windows rg prints 'dir\file' paths, which Git Bash's Vim can't open
let s:rg = 'rg' . (has('win32unix') ? ' --path-separator /' : '')



" Picker -----------------------------------------------------------------------
" Runs the fzf binary in a bottom split terminal and passes the selection to a
" callback. <C-v>/<C-x>/<C-t> open in vsplit/split/tab, <Tab> multi-selects
" (several grep hits go to the quickfix list). Previews use bat if present.
let s:has_fzf = executable('fzf') && has('terminal')
let s:has_bat = executable('bat')
let s:actions = {'': 'edit', 'ctrl-v': 'vsplit', 'ctrl-x': 'split',
      \ 'ctrl-t': 'tabedit'}

" Quote one argument for the script the picker writes (sh or cmd.exe)
function! s:Quote(s) abort
  if has('win32')
    let s = substitute(a:s, '"', '\\"', 'g')
    return '"' . substitute(s, '%', '%%', 'g') . '"'
  endif
  return "'" . substitute(a:s, "'", "'\\\\''", 'g') . "'"
endfunction

" source: shell command that prints lines, a List of lines, or '' (fzf's own
" default). args: List of extra fzf arguments. Sink gets (action, lines).
function! s:Fzf(source, args, Sink) abort
  let s:fzf = {'sink': a:Sink, 'out': tempname(), 'tmp': [],
        \ 'win': win_getid()}
  let expect = filter(keys(s:actions), 'v:val !=# ""')
  let args = ['--layout=reverse', '--info=inline', '--multi',
        \ '--expect=' . join(expect, ',')] + a:args
  let cmd = 'fzf ' . join(map(args, 's:Quote(v:val)'))
  if type(a:source) == v:t_list
    let in = tempname()
    call writefile(a:source, in)
    call add(s:fzf.tmp, in)
    let cmd .= ' < ' . s:Quote(in)
  elseif !empty(a:source)
    let cmd = a:source . ' | ' . cmd
  endif
  let cmd .= ' > ' . s:Quote(s:fzf.out)

  " Run through a script file so quoting/redirection behave the same everywhere
  let script = tempname() . (has('win32') ? '.bat' : '.sh')
  call add(s:fzf.tmp, script)
  call writefile(has('win32')
        \ ? ['@echo off', 'chcp 65001 >nul', cmd] : [cmd], script)
  let job = has('win32') ? ['cmd.exe', '/c', script] : ['sh', script]

  " Open in a full-width split along the bottom; return to the original
  " window when fzf exits so the sink opens files there
  let s:fzf.buf = term_start(job, {'term_finish': 'close',
        \ 'term_rows': s:FzfHeight(),
        \ 'exit_cb': {j, st -> timer_start(10, {-> s:FzfDone(st)})}})
  wincmd J
  execute 'resize' s:FzfHeight()
  " <Esc> goes straight to fzf instead of waiting for the global <Esc><Esc>
  tnoremap <buffer> <nowait> <Esc> <Esc>
endfunction

function! s:FzfHeight() abort
  return max([10, &lines / 2])
endfunction

" Runs after the vimrc's `wincmd =` on VimResized (its autocmd is defined
" first), so an open picker keeps its height
function! s:FzfResize() abort
  let win = bufwinid(get(get(s:, 'fzf', {}), 'buf', -1))
  if win != -1
    call win_execute(win, 'resize ' . s:FzfHeight())
  endif
endfunction

function! s:FzfDone(status) abort
  call win_gotoid(s:fzf.win)
  " term_finish 'close' only closes the window; wipe the finished buffer too
  if has_key(s:fzf, 'buf') && bufexists(s:fzf.buf)
    execute 'silent! bwipeout!' s:fzf.buf
  endif
  let lines = filereadable(s:fzf.out) ? readfile(s:fzf.out) : []
  for f in s:fzf.tmp + [s:fzf.out]
    call delete(f)
  endfor
  if a:status == 0 && len(lines) > 1
    call s:fzf.sink(get(s:actions, lines[0], 'edit'), lines[1:])
  endif
endfunction

function! s:OpenFiles(cmd, files) abort
  for f in a:files
    execute a:cmd fnameescape(f)
  endfor
endfunction

function! s:OpenGrep(cmd, lines) abort
  if len(a:lines) > 1
    call setqflist([], ' ',
          \ {'lines': a:lines, 'efm': '%f:%l:%c:%m', 'title': 'Grep'})
    copen | cfirst
    return
  endif
  let [file, lnum, col] = matchlist(a:lines[0], '\v^(.{-}):(\d+):(\d+):')[1:3]
  execute a:cmd fnameescape(file)
  call cursor(str2nr(lnum), str2nr(col))
  normal! zvzz
endfunction

function! s:FilePreview() abort
  return s:has_bat ? ['--preview',
        \ 'bat --color=always --style=numbers --line-range=:300 {}'] : []
endfunction

function! s:Files() abort
  if !s:has_fzf | call feedkeys(':find ', 'n') | return | endif
  let src = executable('rg')
        \ ? s:rg . ' --files --hidden --glob ' . s:Quote('!.git') : ''
  call s:Fzf(src, ['--prompt', 'Files> '] + s:FilePreview(),
        \ function('s:OpenFiles'))
endfunction

function! s:Buffers() abort
  if !s:has_fzf | call feedkeys(':buffer ', 'n') | return | endif
  let bufs = filter(range(1, bufnr('$')),
        \ 'buflisted(v:val) && v:val != bufnr("%")')
  let names = map(bufs, 'empty(bufname(v:val)) ? v:val . ":[No Name]"'
        \ . ' : fnamemodify(bufname(v:val), ":~:.")')
  call s:Fzf(names, ['--prompt', 'Buffers> '] + s:FilePreview(),
        \ function('s:OpenFiles'))
endfunction

function! s:Recent() abort
  if !s:has_fzf | browse oldfiles | return | endif
  let files = filter(copy(v:oldfiles), 'filereadable(expand(v:val))')
  let files = map(files, 'fnamemodify(expand(v:val), ":~:.")')
  call s:Fzf(files, ['--prompt', 'Recent> ', '--no-sort'] + s:FilePreview(),
        \ function('s:OpenFiles'))
endfunction

" Live grep: rg re-runs on every keystroke, fzf only displays the results
function! s:Grep(query) abort
  if !s:has_fzf || !executable('rg')
    call feedkeys(':silent grep! ' . a:query, 'n') | return
  endif
  let rg = s:rg . ' --column --line-number --no-heading --color=always'
        \ . ' --smart-case -- {q} || ' . (has('win32') ? 'cd .' : 'true')
  let args = ['--prompt', 'Grep> ', '--ansi', '--disabled', '--query', a:query,
        \ '--delimiter', ':',
        \ '--bind', 'start:reload:' . rg, '--bind', 'change:reload:' . rg]
  if s:has_bat
    let args += ['--preview',
          \ 'bat --color=always --style=numbers --highlight-line {2} {1}',
          \ '--preview-window', '+{2}/2']
  endif
  call s:Fzf('', args, function('s:OpenGrep'))
endfunction

command! -nargs=0 Files call s:Files()
command! -nargs=0 Buffers call s:Buffers()
command! -nargs=0 Recent call s:Recent()
command! -nargs=* Grep call s:Grep(<q-args>)

augroup dotfiles_fzf
  autocmd!
  autocmd VimResized * call s:FzfResize()
augroup END



" Keymaps ----------------------------------------------------------------------
nnoremap <silent> <leader><Space> :Files<CR>
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>, :Buffers<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fr :Recent<CR>
nnoremap <silent> <leader>/ :Grep<CR>
nnoremap <silent> <leader>sw :execute 'Grep' expand('<cword>')<CR>
xnoremap <silent> <leader>sw "zy:execute 'Grep' @z<CR>
