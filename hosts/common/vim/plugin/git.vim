" git.vim — git integration, part of the dotfiles' vimrc (follows its style
" guide). GitBranch() for the statusline, and signs for lines changed against
" the index with hunk navigation, staging and resetting.
scriptencoding utf-8
if exists('g:loaded_dotfiles_git') || !executable('git')
  finish
endif
let g:loaded_dotfiles_git = 1



" Branch -----------------------------------------------------------------------
" Git branch of the buffer's directory (or the cwd), cached per buffer
function! s:UpdateBranch() abort
  if !empty(&buftype)
    return
  endif
  " (resolved: a symlink may point into a repository from outside it)
  let dir = fnamemodify(resolve(expand('%:p')), ':h')
  let dir = isdirectory(dir) ? dir : getcwd()
  let out = systemlist('git -C ' . shellescape(dir)
        \ . ' branch --show-current')
  let b:git_branch = v:shell_error || empty(out) ? '' : out[0]
endfunction
function! GitBranch() abort
  let b = get(b:, 'git_branch', '')
  return empty(b) ? '' : ' ⎇ ' . b . ' │'
endfunction
augroup dotfiles_git_branch
  autocmd!
  autocmd BufEnter,FocusGained,ShellCmdPost * call s:UpdateBranch()
augroup END



" Git signs -----------------------------------------------------------------
" Marks lines added, changed or removed relative to the git index in the sign
" column (like mini.diff in Neovim). ]c / [c jump between hunks (or between
" changes in diff mode). Updates on read, write, focus and while typing.
if exists('*sign_place') && has('job') && has('timers')
  call sign_define('GitAdd', {'text': '▌', 'texthl': 'GitSignAdd'})
  call sign_define('GitChange', {'text': '▌', 'texthl': 'GitSignChange'})
  call sign_define('GitDelete', {'text': '▁', 'texthl': 'GitSignDelete'})

  function! s:GitSignHighlights() abort
    let groups = {'Add': ['Added', 'DiffAdd'],
          \ 'Change': ['Changed', 'DiffChange'],
          \ 'Delete': ['Removed', 'DiffDelete']}
    for [name, links] in items(groups)
      let target = hlexists(links[0]) ? links[0] : links[1]
      execute 'highlight default link GitSign' . name target
    endfor
  endfunction
  call s:GitSignHighlights()

  " Per buffer: index version (base), buffer contents (cur), debounce timer,
  " the hunks, the b:changedtick they were computed at (tick; -1 once the
  " index version changed) and the number of the latest diff (seq)
  let s:git = {}
  let s:git_seq = 0
  let s:git_diff = ['git', 'diff', '--no-index', '--no-color',
        \ '--no-ext-diff', '--ignore-cr-at-eol', '-U0']

  " Fetch the index version of the buffer's file, then diff against it
  function! s:GitBase(buf) abort
    let file = resolve(fnamemodify(bufname(a:buf), ':p'))
    if !empty(getbufvar(a:buf, '&buftype')) || !filereadable(file)
      return s:GitForget(a:buf)
    endif
    let base = systemlist('git -C ' . shellescape(fnamemodify(file, ':h'))
          \ . ' show ' . shellescape(':./' . fnamemodify(file, ':t')))
    if v:shell_error
      return s:GitForget(a:buf)
    endif
    if !has_key(s:git, a:buf)
      let s:git[a:buf] = {'base': tempname(), 'cur': tempname(),
            \ 'timer': -1, 'hunks': [], 'tick': -1, 'seq': 0}
    endif
    call writefile(base, s:git[a:buf].base)
    " The hunks are against the previous index version until the diff is done
    let s:git[a:buf].tick = -1
    call s:GitDiff(a:buf)
  endfunction

  function! s:GitForget(buf) abort
    if has_key(s:git, a:buf)
      call timer_stop(s:git[a:buf].timer)
      call delete(s:git[a:buf].base)
      call delete(s:git[a:buf].cur)
      call remove(s:git, a:buf)
    endif
    if bufexists(a:buf)
      call sign_unplace('gitsigns', {'buffer': a:buf})
    endif
  endfunction

  " Diff the buffer contents against the index version: in the background, or
  " before returning if a:1 is given
  function! s:GitDiff(buf, ...) abort
    if !has_key(s:git, a:buf) || !bufloaded(a:buf)
      return
    endif
    let buf = a:buf
    let st = s:git[buf]
    let s:git_seq += 1
    let [seq, tick] = [s:git_seq, getbufvar(buf, 'changedtick')]
    let st.seq = seq
    call writefile(getbufline(buf, 1, '$'), st.cur)
    let cmd = s:git_diff + [st.base, st.cur]
    if a:0
      let out = systemlist(join(map(cmd, {_, arg -> shellescape(arg)})))
      return s:GitPlace(buf, seq, tick, out)
    endif
    let out = []
    call job_start(cmd, {'in_io': 'null', 'err_io': 'null',
          \ 'out_cb': {_, l -> add(out, l)},
          \ 'close_cb': {_ -> s:GitPlace(buf, seq, tick, out)}})
  endfunction

  " Parse the '@@ -old,count +new,count @@' hunks, keeping each hunk's body
  " (for staging/resetting), and turn them into signs. A hunk's 'lnums' are
  " the buffer lines it marks; a deletion marks the line above it. The
  " output of any but the latest diff (a:seq) is out of date and dropped.
  function! s:GitPlace(buf, seq, tick, out) abort
    if !has_key(s:git, a:buf) || !bufloaded(a:buf)
          \ || s:git[a:buf].seq != a:seq
      return
    endif
    call sign_unplace('gitsigns', {'buffer': a:buf})
    let hunks = []
    let rx = '^@@ -\(\d\+\)\%(,\(\d\+\)\)\? +\(\d\+\)\%(,\(\d\+\)\)\? @@'
    for l in a:out
      let m = matchlist(l, rx)
      if empty(m)
        if !empty(hunks) && l =~# '^[-+\\]'
          call add(hunks[-1].body, l)
        endif
        continue
      endif
      let h = {'old': str2nr(m[1]), 'oldc': m[2] ==# '' ? 1 : str2nr(m[2]),
            \ 'new': str2nr(m[3]), 'newc': m[4] ==# '' ? 1 : str2nr(m[4]),
            \ 'body': []}
      if h.newc == 0
        let h.lnums = [max([1, h.new])]
        let sign = 'GitDelete'
      else
        let h.lnums = range(h.new, h.new + h.newc - 1)
        let sign = h.oldc == 0 ? 'GitAdd' : 'GitChange'
      endif
      call add(hunks, h)
      for lnum in h.lnums
        call sign_place(0, 'gitsigns', sign, a:buf,
              \ {'lnum': lnum, 'priority': 5})
      endfor
    endfor
    let s:git[a:buf].hunks = hunks
    let s:git[a:buf].tick = a:tick
  endfunction

  " The current buffer's hunks. The background diff lags behind changes to
  " the buffer and the index, so diff again first if they are out of date.
  function! s:GitHunks() abort
    let buf = bufnr('%')
    if has_key(s:git, buf) && s:git[buf].tick != b:changedtick
      call s:GitDiff(buf, 1)
    endif
    return get(get(s:git, buf, {}), 'hunks', [])
  endfunction

  function! s:GitHunkAtCursor() abort
    for h in s:GitHunks()
      if index(h.lnums, line('.')) >= 0
        return h
      endif
    endfor
    echo 'No hunk under the cursor'
    return {}
  endfunction

  " Stage the hunk under the cursor (as it is in the buffer, saved or not)
  function! s:GitStageHunk() abort
    let h = s:GitHunkAtCursor()
    if empty(h)
      return
    endif
    " (resolved, like in s:GitBase: the file may be a symlink into the repo)
    let file = resolve(expand('%:p'))
    let dir = shellescape(fnamemodify(file, ':h'))
    let top = systemlist('git -C ' . dir . ' rev-parse --show-toplevel')
    let path = systemlist('git -C ' . dir . ' ls-files --full-name -- '
          \ . shellescape(file))
    if v:shell_error || empty(top) || empty(path)
      echohl ErrorMsg | echo 'Not a tracked git file' | echohl None
      return
    endif
    " With -U0, git places the hunk by its old start; the new start only
    " has to be consistent with it
    let new = h.oldc == 0 ? h.old + 1 : h.newc == 0 ? h.old - 1 : h.old
    let patch = ['diff --git a/' . path[0] . ' b/' . path[0],
          \ '--- a/' . path[0], '+++ b/' . path[0],
          \ printf('@@ -%d,%d +%d,%d @@', h.old, h.oldc, new, h.newc)]
          \ + h.body
    let out = system('git -C ' . shellescape(top[0])
          \ . ' apply --cached --unidiff-zero -', join(patch, "\n") . "\n")
    if v:shell_error
      echohl ErrorMsg | echo 'git apply: ' . trim(out) | echohl None
      return
    endif
    call s:GitBase(bufnr('%'))
  endfunction

  " Replace the hunk under the cursor with the index version
  function! s:GitResetHunk() abort
    let h = s:GitHunkAtCursor()
    if empty(h)
      return
    endif
    let old = map(filter(copy(h.body), {_, l -> l[0] ==# '-'}),
          \ {_, l -> l[1:]})
    " (not :delete, which extends its range to whole closed folds)
    if h.newc > 0
      call deletebufline('%', h.new, h.new + h.newc - 1)
    endif
    call append(h.newc > 0 ? h.new - 1 : h.new, old)
    call cursor(max([1, h.new]), 1)
  endfunction
  nnoremap <silent> <leader>ghs :call <SID>GitStageHunk()<CR>
  nnoremap <silent> <leader>ghr :call <SID>GitResetHunk()<CR>

  function! s:GitSchedule(buf) abort
    if !has_key(s:git, a:buf)
      return
    endif
    let buf = a:buf
    call timer_stop(s:git[buf].timer)
    let s:git[buf].timer = timer_start(150, {-> s:GitDiff(buf)})
  endfunction

  function! s:GitHunk(dir) abort
    if &diff
      execute 'normal!' v:count1 . (a:dir > 0 ? ']c' : '[c')
      return
    endif
    let hunks = map(copy(s:GitHunks()), {_, h -> h.lnums[0]})
    let lnum = line('.')
    let targets = a:dir > 0
          \ ? filter(copy(hunks), {_, h -> h > lnum})
          \ : reverse(filter(copy(hunks), {_, h -> h < lnum}))
    if !empty(targets)
      execute 'normal!' targets[min([v:count1, len(targets)]) - 1] . 'G'
    endif
  endfunction
  nnoremap <silent> ]c :<C-u>call <SID>GitHunk(1)<CR>
  nnoremap <silent> [c :<C-u>call <SID>GitHunk(-1)<CR>

  augroup vimrc_gitsigns
    autocmd!
    autocmd BufReadPost,BufWritePost,FileChangedShellPost *
          \ call s:GitBase(str2nr(expand('<abuf>')))
    autocmd FocusGained,ShellCmdPost * call s:GitBase(bufnr('%'))
    autocmd TextChanged,TextChangedI,InsertLeave *
          \ call s:GitSchedule(bufnr('%'))
    autocmd BufWipeout * call s:GitForget(str2nr(expand('<abuf>')))
    autocmd ColorScheme * call s:GitSignHighlights()
  augroup END
endif
