" which.vim — lists the keys that can follow a prefix, part of the dotfiles'
" vimrc (follows its style guide). Like mini.clue in the Neovim config: type
" <leader>, g, z, [, ] or <C-w>, pause, and the possible next keys are listed
" in the command-line area (no window is opened). <Esc> cancels.
"
" Your own mappings are found with maplist() and described by their
" right-hand side, or by s:desc below. Vim's built-in commands and their
" descriptions are read from $VIMRUNTIME/doc/index.txt.
scriptencoding utf-8
if exists('g:loaded_dotfiles_which') || !exists('*keytrans')
      \ || !exists('*maplist')
  finish
endif
let g:loaded_dotfiles_which = 1

" Milliseconds to wait for the next key before the list is shown
let s:delay = 200
let s:leader = keytrans(get(g:, 'mapleader', '\'))
let s:triggers = [['n', s:leader], ['x', s:leader], ['n', 'g'], ['x', 'g'],
      \ ['n', 'z'], ['x', 'z'], ['n', '<C-W>'], ['n', '['], ['n', ']']]

" Names for groups of mappings, by prefix (in keytrans() notation)
let s:groups = {
      \ s:leader . 'b': 'Buffers', s:leader . 'c': 'Code',
      \ s:leader . 'f': 'Files',
      \ s:leader . 'g': 'Git', s:leader . 'gh': 'Hunks',
      \ s:leader . 'q': 'Quit', s:leader . 's': 'Search',
      \ s:leader . 'u': 'UI', s:leader . 'w': 'Windows',
      \ s:leader . 'x': 'Lists', s:leader . '<Tab>': 'Tabs'}

" Descriptions for mappings whose right-hand side doesn't explain itself
let s:desc = {
      \ s:leader . '<Space>': 'Find files', s:leader . ',': 'Buffers',
      \ s:leader . '/': 'Live grep', s:leader . 'e': 'File explorer',
      \ s:leader . 'bd': 'Delete buffer', s:leader . 'fb': 'Buffers',
      \ s:leader . 'ff': 'Find files', s:leader . 'fn': 'New file',
      \ s:leader . 'fr': 'Recent files', s:leader . 'ft': 'Terminal',
      \ s:leader . 'fy': 'Copy relative path',
      \ s:leader . 'ghr': 'Reset hunk', s:leader . 'ghs': 'Stage hunk',
      \ s:leader . 'qq': 'Quit all', s:leader . 'sg': 'Grep (quickfix)',
      \ s:leader . 'sr': 'Replace word in file',
      \ s:leader . 'sw': 'Grep word under cursor',
      \ s:leader . 'uL': 'Toggle relative numbers',
      \ s:leader . 'uS': 'Toggle colorcolumn',
      \ s:leader . 'ul': 'Toggle listchars',
      \ s:leader . 'ur': 'Clear search / redraw',
      \ s:leader . 'us': 'Toggle spelling',
      \ s:leader . 'uv': 'Toggle cursorline', s:leader . 'uw': 'Toggle wrap',
      \ s:leader . 'w-': 'Split below', s:leader . 'w<Bar>': 'Split right',
      \ s:leader . 'wd': 'Close window', s:leader . 'ww': 'Other window',
      \ s:leader . 'xl': 'Location list', s:leader . 'xq': 'Quickfix list',
      \ s:leader . '<Tab><Tab>': 'New tab', s:leader . '<Tab>d': 'Close tab',
      \ s:leader . '<Tab>]': 'Next tab', s:leader . '<Tab>[': 'Previous tab',
      \ s:leader . '<Tab>f': 'First tab', s:leader . '<Tab>l': 'Last tab',
      \ '[b': 'Previous buffer', ']b': 'Next buffer',
      \ '[c': 'Previous hunk', ']c': 'Next hunk',
      \ '[l': 'Previous location', ']l': 'Next location',
      \ '[q': 'Previous quickfix', ']q': 'Next quickfix',
      \ 'gc': 'Toggle comment', 'gcc': 'Toggle comment on line',
      \ s:leader . 'ca': 'Code action', s:leader . 'cA': 'Source action',
      \ s:leader . 'cd': 'Line diagnostics', s:leader . 'cf': 'Format',
      \ s:leader . 'ch': 'Switch source/header',
      \ s:leader . 'xx': 'Diagnostics list',
      \ '[d': 'Previous diagnostic', ']d': 'Next diagnostic',
      \ 'gd': 'Goto definition', 'gD': 'Goto declaration',
      \ 'gO': 'Document symbols', 'gra': 'Code action', 'grn': 'Rename',
      \ 'gri': 'Goto implementation', 'grr': 'References',
      \ 'grt': 'Goto type definition',
      \ '<C-W>H': 'Narrower', '<C-W>L': 'Wider',
      \ '<C-W>J': 'Shorter', '<C-W>K': 'Taller'}



" Keys -------------------------------------------------------------------------
" Split raw key codes into a List of keys in keytrans() notation:
" "\<C-w>gf" -> ['<C-W>', 'g', 'f']
function! s:Tokens(raw) abort
  let toks = []
  call substitute(keytrans(a:raw), '<[^<> ]\+>\|.',
        \ '\=add(toks, submatch(0))[-1]', 'g')
  return toks
endfunction

" The raw key code for one key in <> notation
function! s:Raw(key) abort
  return a:key =~# '^<.\+>$' ? eval('"\' . a:key . '"') : a:key
endfunction

" Turn a command as written in index.txt ('CTRL-W g CTRL-]', 'zf{motion}',
" '["x]gp') into raw key codes; '' if it can't be typed (mouse, CTRL-?)
function! s:DocKeys(cmd) abort
  let cmd = substitute(a:cmd, '^\["x\]', '', '')
  let raw = ''
  while cmd !=# '' && cmd !~# '^{\a[^}]*}'
    let t = matchstr(cmd, '^\%(CTRL-.\|<[A-Za-z0-9-]\+>\|.\)')
    let cmd = strpart(cmd, len(t))
    if t =~# '^CTRL-'
      let c = char2nr(toupper(t[5:]))
      if c <= 64 || c > 95
        return ''
      endif
      let raw .= nr2char(c - 64)
    elseif t =~# '^<.\+>$'
      if t =~? 'mouse'
        return ''
      endif
      let raw .= s:Raw(t)
    elseif t !=# ' '
      let raw .= t
    endif
  endwhile
  return raw
endfunction



" Entries ----------------------------------------------------------------------
" An entry is {'keys': List of keys, 'desc': description}

" Built-in <C-w>, [, ], g and z commands, read once from index.txt
function! s:Builtins() abort
  if exists('s:builtins')
    return s:builtins
  endif
  let s:builtins = []
  let file = expand('$VIMRUNTIME/doc/index.txt')
  let lines = filereadable(file) ? readfile(file) : []
  let from = match(lines, '\*CTRL-W\*')
  let to = match(lines, '\*operator-pending-index\*')
  if from < 0 || to < from
    return s:builtins
  endif
  " |tag|  command  [note]  description
  let rx = '^|[^|]\+|\s\+\(.\{-1,}\)\%(\t\+\| \{2,}\)\s*'
        \ . '\%([12,]\+  \)\?\(\S.*\)$'
  for l in lines[from : to]
    let m = matchlist(l, rx)
    if empty(m) || m[2] =~# '^same as'
      continue
    endif
    let raw = s:DocKeys(m[1])
    if raw !=# ''
      " Drop the bars of help tags such as |:only|
      call add(s:builtins, {'keys': s:Tokens(raw),
            \ 'desc': substitute(m[2], '|\(\S\{-1,}\)|', '\1', 'g')})
    endif
  endfor
  return s:builtins
endfunction

" A mapping's description: s:desc, or else its tidied right-hand side
function! s:Desc(map) abort
  let desc = get(s:desc, keytrans(a:map.lhsraw), '')
  if desc !=# ''
    return desc
  endif
  let rhs = substitute(a:map.rhs, '\c^\%(<Cmd>\|:\)\%(<C-U>\)\?', '', '')
  let rhs = substitute(rhs, '\c<CR>$', '', '')
  let rhs = substitute(rhs, '\c\%(call \)\?\%(<SID>\|<SNR>\d\+_\)', '', 'g')
  return substitute(rhs, '\c^<Plug>(\(.*\))$', '\1', '')
endfunction

" Built-ins plus the mappings of a mode ('n' or 'x'); mappings win
function! s:Entries(mode) abort
  let entries = {}
  for b in s:Builtins()
    let entries[join(b.keys, '')] = b
  endfor
  let modes = a:mode ==# 'n' ? '[n ]' : '[xv ]'
  for m in maplist()
    if m.mode =~# modes && m.lhs !~# '^<\%(Plug\|SNR\)>'
      let keys = s:Tokens(m.lhsraw)
      let entries[join(keys, '')] = {'keys': keys, 'desc': s:Desc(m)}
    endif
  endfor
  return values(entries)
endfunction



" List -------------------------------------------------------------------------
" Lowercase before uppercase, special keys last
function! s:SortKey(key) abort
  return (len(a:key) > 1 ? '~' : '') . tolower(a:key)
        \ . (a:key ==# tolower(a:key) ? 0 : 1)
endfunction

function! s:Fit(text, width) abort
  let text = strdisplaywidth(a:text) > a:width
        \ ? strcharpart(a:text, 0, a:width - 1) . '…' : a:text
  return text . repeat(' ', a:width - strdisplaywidth(text))
endfunction

" Keys that read better as themselves than in keytrans() notation
let s:names = {'<lt>': '<', '<Bar>': '|', '<Bslash>': '\'}

" Echo the keys that can follow a:toks, in columns
function! s:Show(toks, cands) abort
  let n = len(a:toks)
  let next = {}
  for c in a:cands
    let k = c.keys[n]
    let next[k] = get(next, k, {'count': 0, 'desc': ''})
    let next[k].count += 1
    if len(c.keys) == n + 1
      let next[k].desc = c.desc
    endif
  endfor

  let items = []
  for k in sort(keys(next), {a, b -> s:SortKey(a) ==# s:SortKey(b) ? 0
        \ : s:SortKey(a) ># s:SortKey(b) ? 1 : -1})
    let group = get(s:groups, join(a:toks, '') . k, '')
    if group !=# ''
      let item = {'text': '+' . group, 'hl': 'Directory'}
    elseif next[k].desc ==# ''
      let item = {'text': '+' . next[k].count . ' more', 'hl': 'Directory'}
    else
      let item = {'text': next[k].desc . (next[k].count > 1 ? ' …' : ''),
            \ 'hl': 'None'}
    endif
    call add(items, extend(item, {'key': get(s:names, k, k)}))
  endfor

  " Columns up to 32 wide, narrower if the list wouldn't fit on the screen
  let kw = max(map(copy(items), {_, i -> strdisplaywidth(i.key)}))
  let tw = min([32, max(map(copy(items), {_, i -> strdisplaywidth(i.text)}))])
  let cols = max([1, (&columns - 1) / (kw + tw + 4)])
  let maxrows = max([1, &lines - 4])
  if len(items) > cols * maxrows
    let cols = (len(items) + maxrows - 1) / maxrows
    let tw = max([8, (&columns - 1) / cols - kw - 4])
  endif
  let rows = min([(len(items) + cols - 1) / cols, maxrows])

  let more = &more
  set nomore
  redraw
  echohl Title | echo ' ' . join(a:toks, ' ') | echohl None
  for r in range(rows)
    echon "\n"
    for c in range(cols)
      let item = get(items, c * rows + r, {})
      if empty(item)
        break
      endif
      echohl Special | echon ' ' . s:Fit(item.key, kw + 1)
      execute 'echohl' item.hl
      echon s:Fit(item.text, tw + 2)
      echohl None
    endfor
  endfor
  let &more = more
endfunction



" Triggers ---------------------------------------------------------------------
" Wait up to s:delay ms for a key; '' if none was typed
function! s:Poll() abort
  let start = reltime()
  while reltimefloat(reltime(start)) * 1000 < s:delay
    let c = getcharstr(0)
    if c !=# ''
      return c
    endif
    sleep 5m
  endwhile
  return ''
endfunction

" Collect keys after a trigger until nothing longer can follow, then run
" them. The list is shown once the user pauses.
function! s:Trigger(i) abort
  let [mode, key] = s:triggers[a:i]
  let default = &clipboard =~# 'unnamedplus' ? '+'
        \ : &clipboard =~# 'unnamed' ? '*' : '"'
  let before = (v:register ==# default ? '' : '"' . v:register)
        \ . (v:count ? v:count : '')
  let typed = s:Raw(key)
  let entries = s:Entries(mode)
  let shown = 0
  while 1
    let toks = s:Tokens(typed)
    let n = len(toks)
    let cands = filter(copy(entries),
          \ {_, e -> len(e.keys) > n && e.keys[: n - 1] == toks})
    if empty(cands)
      break
    endif
    try
      let c = shown ? '' : s:Poll()
      if c ==# ''
        call s:Show(toks, cands)
        let shown = 1
        let c = getcharstr()
      endif
    catch /^Vim:Interrupt$/
      let c = "\<Esc>"
    endtry
    if c ==# "\<Esc>" || c ==# "\<C-c>"
      redraw
      echo ''
      return
    endif
    let typed .= c
  endwhile
  if shown
    redraw
    echo ''
  endif
  " Run the keys with mappings applied, but without the triggers (or this
  " would loop); they come back once Vim waits for input again
  call s:Unmap()
  call feedkeys(before . typed, 'mi')
  call timer_start(0, {-> s:Map()})
endfunction

" Buffer-local <nowait> mappings, so that a trigger fires at once instead of
" waiting for the rest of a longer global mapping (such as <leader>ff)
function! s:Map() abort
  if exists('b:which_triggers')
    return
  endif
  let b:which_triggers = []
  for i in range(len(s:triggers))
    let [mode, key] = s:triggers[i]
    " Leave a buffer's own mapping of the same key alone
    if !get(maparg(key, mode, 0, 1), 'buffer', 0)
      execute mode . 'noremap <buffer> <nowait>' key
            \ '<Cmd>call <SID>Trigger(' . i . ')<CR>'
      call add(b:which_triggers, i)
    endif
  endfor
endfunction

function! s:Unmap() abort
  for i in get(b:, 'which_triggers', [])
    execute 'silent!' s:triggers[i][0] . 'unmap <buffer>' s:triggers[i][1]
  endfor
  unlet! b:which_triggers
endfunction

augroup dotfiles_which
  autocmd!
  autocmd VimEnter,BufEnter * call s:Map()
augroup END
