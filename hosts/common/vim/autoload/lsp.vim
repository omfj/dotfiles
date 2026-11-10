" autoload/lsp.vim — the client behind plugin/lsp.vim (see there for the
" servers and keys). Part of the dotfiles' vimrc; follows its style guide.
"
" One server runs per (server, project root) and is shared by its buffers.
" Buffers are synced by sending their full text after changes (debounced,
" and always before a request and after applying a server's edits).
scriptencoding utf-8

" key ('name root') -> {name, root, job, ch, ready, enc, caps, pending, bufs}
let s:servers = {}
" Servers that failed to start; not retried until :LspRestart
let s:failed = {}
" bufnr -> List of diagnostics, sorted by position
let s:diags = {}
" bufnr -> diagnostics that arrived in insert mode, shown on InsertLeave
let s:deferred = {}
" bufnr -> debounce timer for syncing changes
let s:timers = {}

let s:severity = ['Error', 'Warn', 'Info', 'Hint']
let s:symbol_kinds = ['File', 'Module', 'Namespace', 'Package', 'Class',
      \ 'Method', 'Property', 'Field', 'Constructor', 'Enum', 'Interface',
      \ 'Function', 'Variable', 'Constant', 'String', 'Number', 'Boolean',
      \ 'Array', 'Object', 'Key', 'Null', 'EnumMember', 'Struct', 'Event',
      \ 'Operator', 'TypeParameter']
let s:item_kinds = ['Text', 'Method', 'Function', 'Constructor', 'Field',
      \ 'Variable', 'Class', 'Interface', 'Module', 'Property', 'Unit',
      \ 'Value', 'Enum', 'Keyword', 'Snippet', 'Color', 'File', 'Reference',
      \ 'Folder', 'EnumMember', 'Constant', 'Struct', 'Event', 'Operator',
      \ 'TypeParameter']

function! s:Echo(msg, ...) abort
  execute 'echohl' get(a:, 1, 'None')
  echo strcharpart('LSP: ' . split(a:msg . ' ', "\n")[0], 0, &columns - 15)
  echohl None
endfunction



" Highlights and signs ---------------------------------------------------------
function! s:Highlights() abort
  highlight default link LspErrorText ErrorMsg
  highlight default link LspWarnText WarningMsg
  highlight default link LspInfoText Identifier
  highlight default link LspHintText Comment
  highlight default link LspErrorUnder SpellBad
  highlight default link LspWarnUnder SpellCap
  highlight default link LspInfoUnder SpellRare
  highlight default link LspHintUnder SpellLocal
endfunction
call s:Highlights()
augroup lsp_highlights
  autocmd!
  autocmd ColorScheme * call s:Highlights()
augroup END

" Signs as in the Neovim config. Text properties: an underline for the
" range and, except for hints, the message after the end of the line.
let s:sign_text = ['✘', '▲', '»', '⚑']
for s:i in range(4)
  let s:name = s:severity[s:i]
  call sign_define('Lsp' . s:name,
        \ {'text': s:sign_text[s:i], 'texthl': 'Lsp' . s:name . 'Text'})
  for s:kind in ['Under', 'Text']
    if empty(prop_type_get('Lsp' . s:name . s:kind))
      call prop_type_add('Lsp' . s:name . s:kind,
            \ {'highlight': 'Lsp' . s:name . s:kind, 'combine': 1})
    endif
  endfor
endfor
let s:prop_types = map(copy(s:severity), {_, s -> 'Lsp' . s . 'Under'})
      \ + map(copy(s:severity), {_, s -> 'Lsp' . s . 'Text'})



" Paths and positions ----------------------------------------------------------
function! s:Uri(path) abort
  let path = fnamemodify(a:path, ':p')
  if has('win32')
    let path = '/' . tr(path, '\', '/')
  endif
  " Percent-encode byte by byte
  return 'file://' . join(map(range(len(path)), {_, i ->
        \ path[i] =~# '[A-Za-z0-9/._~:-]' ? path[i]
        \ : printf('%%%02X', char2nr(path[i]))}), '')
endfunction

function! s:Path(uri) abort
  let path = substitute(a:uri, '^file://', '', '')
  let path = substitute(path, '%\(\x\x\)',
        \ '\=eval(''"\x'' . submatch(1) . ''"'')', 'g')
  return has('win32') ? substitute(path, '^/\(\a:\)', '\1', '') : path
endfunction

" Servers count columns in UTF-16 units unless they agreed to UTF-8 (bytes).
" 1-based byte column in a:text for a server's 0-based character
function! s:Col(server, text, character) abort
  if a:server.enc ==# 'utf-8'
    return min([a:character, len(a:text)]) + 1
  endif
  let idx = byteidx(a:text, a:character, 1)
  return (idx < 0 ? len(a:text) : idx) + 1
endfunction

" The server's position for line a:lnum and 1-based byte column a:col
function! s:Pos(server, lnum, col) abort
  let before = strpart(getline(a:lnum), 0, a:col - 1)
  return {'line': a:lnum - 1, 'character': a:server.enc ==# 'utf-8'
        \ ? len(before) : strutf16len(before)}
endfunction

function! s:Doc(...) abort
  return {'uri': s:Uri(bufname(a:0 ? a:1 : '%'))}
endfunction

" textDocument + cursor position, the parameters of most requests
function! s:Here(server) abort
  return {'textDocument': s:Doc(),
        \ 'position': s:Pos(a:server, line('.'), col('.'))}
endfunction

" The visual selection (leaving visual mode), or else the cursor
function! s:Range(server) abort
  let [a, b] = [getpos('.')[1:2], getpos('.')[1:2]]
  let mode = mode()
  if mode =~# "^[vV\<C-v>]"
    let a = getpos('v')[1:2]
    if a[0] > b[0] || (a[0] == b[0] && a[1] > b[1])
      let [a, b] = [b, a]
    endif
    if mode ==# 'V'
      let [a[1], b[1]] = [1, len(getline(b[0])) + 1]
    else
      let b[1] += len(matchstr(getline(b[0]), '\%' . b[1] . 'c.'))
    endif
    execute "normal! \<Esc>"
  endif
  return {'start': s:Pos(a:server, a[0], a[1]),
        \ 'end': s:Pos(a:server, b[0], b[1])}
endfunction

" A line of a file, loaded in a buffer or not
function! s:LineText(path, lnum) abort
  let buf = bufnr(a:path)
  if buf > 0 && bufloaded(buf)
    return get(getbufline(buf, a:lnum), 0, '')
  endif
  return filereadable(a:path) ? get(readfile(a:path, '', a:lnum), -1, '') : ''
endfunction

function! s:Root(dir, markers) abort
  for marker in a:markers
    let dir = a:dir
    while 1
      if !empty(glob(dir . '/' . marker, 1, 1))
        return dir
      endif
      let up = fnamemodify(dir, ':h')
      if up ==# dir
        break
      endif
      let dir = up
    endwhile
  endfor
  return a:dir
endfunction



" Servers ----------------------------------------------------------------------
function! s:Server(buf) abort
  return get(s:servers, getbufvar(a:buf, 'lsp', ''), {})
endfunction

" Attach the current buffer to its server, starting it if needed
function! lsp#Start() abort
  let cfg = get(g:dotfiles_lsp, &filetype, {})
  let file = expand('%:p')
  if empty(cfg) || !empty(&buftype) || !filereadable(file)
        \ || get(b:, 'lsp', '') !=# ''
    return
  endif
  let cmds = filter(copy(cfg.cmds), {_, c -> executable(c[0])})
  if empty(cmds)
    return
  endif
  let root = s:Root(fnamemodify(file, ':h'), cfg.root)
  let key = cfg.name . ' ' . root
  if has_key(s:failed, key)
        \ || (!has_key(s:servers, key) && !s:Launch(key, cfg, cmds[0], root))
    return
  endif
  let server = s:servers[key]
  let buf = bufnr('%')
  let b:lsp = key
  let b:lsp_lang = cfg.lang
  if server.ready
    call s:Open(server, buf)
  else
    call add(server.pending, buf)
  endif

  " Completion: a 'complete' source where Vim has those, and omni completion
  setlocal omnifunc=lsp#Complete
  try
    setlocal complete^=Flsp#Complete
  catch /^Vim\%((\a\+)\)\=:E47[45]:/
  endtry
  augroup lsp_buffer
    autocmd! * <buffer>
    autocmd TextChanged,TextChangedI <buffer>
          \ call s:Schedule(str2nr(expand('<abuf>')))
    autocmd InsertLeave <buffer> call s:Sync(str2nr(expand('<abuf>')))
          \ | call s:ShowDeferred(str2nr(expand('<abuf>')))
    autocmd BufWritePost <buffer> call s:Saved(str2nr(expand('<abuf>')))
    autocmd BufDelete <buffer> call s:Close(str2nr(expand('<abuf>')))
    autocmd CompleteDone <buffer> call s:CompleteDone()
    autocmd InsertCharPre <buffer> call s:TriggerCompletion()
  augroup END
endfunction

function! s:Launch(key, cfg, cmd, root) abort
  let key = a:key
  let server = {'key': key, 'name': a:cfg.name, 'root': a:root, 'ready': 0,
        \ 'enc': 'utf-16', 'caps': {}, 'pending': [], 'bufs': {}}
  let server.job = job_start(a:cmd, {'in_mode': 'lsp', 'out_mode': 'lsp',
        \ 'err_mode': 'nl', 'noblock': 1, 'cwd': a:root,
        \ 'out_cb': {_, msg -> s:OnMessage(key, msg)},
        \ 'err_cb': {_, msg -> 0},
        \ 'exit_cb': {_, status -> s:OnExit(key)}})
  if job_status(server.job) !=# 'run'
    let s:failed[key] = 1
    call s:Echo('could not start ' . a:cmd[0], 'ErrorMsg')
    return 0
  endif
  let server.ch = job_getchannel(server.job)
  let s:servers[key] = server
  let folder = {'uri': s:Uri(a:root), 'name': fnamemodify(a:root, ':t')}
  let kinds = ['quickfix', 'refactor', 'refactor.extract', 'refactor.inline',
        \ 'refactor.rewrite', 'source', 'source.organizeImports']
  call s:Request(server, 'initialize', {
        \ 'processId': getpid(), 'rootUri': folder.uri, 'rootPath': a:root,
        \ 'workspaceFolders': [folder],
        \ 'initializationOptions': a:cfg.init,
        \ 'capabilities': {
        \   'general': {'positionEncodings': ['utf-8', 'utf-16']},
        \   'offsetEncoding': ['utf-8', 'utf-16'],
        \   'workspace': {'applyEdit': v:true, 'configuration': v:true,
        \     'workspaceFolders': v:true,
        \     'workspaceEdit': {'documentChanges': v:true}},
        \   'textDocument': {
        \     'synchronization': {'didSave': v:true},
        \     'completion': {'completionItem': {'snippetSupport': v:false,
        \       'documentationFormat': ['plaintext'],
        \       'resolveSupport': {'properties': ['additionalTextEdits']}}},
        \     'hover': {'contentFormat': ['markdown', 'plaintext']},
        \     'signatureHelp': {'signatureInformation':
        \       {'documentationFormat': ['plaintext']}},
        \     'documentSymbol': {'hierarchicalDocumentSymbolSupport': v:true},
        \     'codeAction': {'codeActionLiteralSupport':
        \       {'codeActionKind': {'valueSet': kinds}}},
        \     'publishDiagnostics': {'relatedInformation': v:false},
        \     'definition': {'linkSupport': v:true},
        \     'rename': {}, 'references': {}, 'formatting': {}}}},
        \ {result -> s:OnInit(key, a:cfg, result)})
  return 1
endfunction

function! s:OnInit(key, cfg, result) abort
  let server = get(s:servers, a:key, {})
  if empty(server) || type(a:result) != v:t_dict
    return
  endif
  let server.caps = get(a:result, 'capabilities', {})
  " clangd before 3.17 support answers with a top-level offsetEncoding
  let server.enc = get(server.caps, 'positionEncoding',
        \ get(a:result, 'offsetEncoding', 'utf-16'))
  let server.ready = 1
  call s:Notify(server, 'initialized', {})
  if !empty(a:cfg.init)
    call s:Notify(server, 'workspace/didChangeConfiguration',
          \ {'settings': {a:cfg.name : a:cfg.init}})
  endif
  for buf in server.pending
    if bufloaded(buf)
      call s:Open(server, buf)
    endif
  endfor
  let server.pending = []
endfunction

function! s:OnExit(key) abort
  let server = get(s:servers, a:key, {})
  if empty(server)
    return
  endif
  call remove(s:servers, a:key)
  if !server.ready
    let s:failed[a:key] = 1
    call s:Echo(server.name . ' exited during startup', 'ErrorMsg')
  endif
  for buf in map(keys(server.bufs) + server.pending, {_, b -> str2nr(b)})
    if bufexists(buf)
      call setbufvar(buf, 'lsp', '')
      call s:SetDiagnostics(buf, [])
    endif
  endfor
endfunction

function! s:Request(server, method, params, Callback) abort
  let method = a:method
  let Callback = a:Callback
  call ch_sendexpr(a:server.ch, {'method': method, 'params': a:params},
        \ {'callback': {_, msg -> s:OnReply(method, msg, Callback)}})
endfunction

function! s:OnReply(method, msg, Callback) abort
  if has_key(a:msg, 'error')
    " Not worth a message: content modified, request cancelled
    if index([-32801, -32800], get(a:msg.error, 'code', 0)) < 0
      call s:Echo(a:method . ': ' . get(a:msg.error, 'message', 'error'),
            \ 'ErrorMsg')
    endif
    return
  endif
  call a:Callback(get(a:msg, 'result', v:null))
endfunction

function! s:Notify(server, method, params) abort
  call ch_sendexpr(a:server.ch, {'method': a:method, 'params': a:params})
endfunction

" Notifications and requests from the server
function! s:OnMessage(key, msg) abort
  let server = get(s:servers, a:key, {})
  let method = get(a:msg, 'method', '')
  if empty(server) || method ==# ''
    return
  endif
  let params = get(a:msg, 'params', {})
  if method ==# 'textDocument/publishDiagnostics'
    call s:OnDiagnostics(server, params)
  elseif method ==# 'window/showMessage' && get(params, 'type', 4) <= 2
    call s:Echo(get(params, 'message', ''), 'WarningMsg')
  endif
  if !has_key(a:msg, 'id')
    return
  endif
  " A request: it must be answered, with null if it means nothing to us
  let result = v:null
  if method ==# 'workspace/configuration'
    let result = map(copy(get(params, 'items', [])), {-> v:null})
  elseif method ==# 'workspace/applyEdit'
    call s:ApplyWorkspaceEdit(server, get(params, 'edit', {}))
    let result = {'applied': v:true}
  elseif method ==# 'workspace/workspaceFolders'
    let result = [{'uri': s:Uri(server.root),
          \ 'name': fnamemodify(server.root, ':t')}]
  endif
  call ch_sendexpr(server.ch, {'id': a:msg.id, 'result': result})
endfunction

" Run a request for the current buffer; Callback gets (server, result)
function! s:Call(method, Params, Callback) abort
  let server = s:Server(bufnr('%'))
  if empty(server) || !server.ready
    call s:Echo(empty(server) ? 'no server for this buffer'
          \ : server.name . ' is still starting')
    return
  endif
  call s:Sync(bufnr('%'))
  let Callback = a:Callback
  call s:Request(server, a:method, a:Params(server),
        \ {result -> Callback(server, result)})
endfunction

function! lsp#Info() abort
  if empty(s:servers)
    echo 'LSP: no servers running'
  endif
  for server in values(s:servers)
    echo printf('%s  %s  %s, %d buffer(s), %s', server.name, server.root,
          \ server.ready ? 'ready' : 'starting', len(server.bufs), server.enc)
  endfor
endfunction

function! lsp#Stop() abort
  for server in values(s:servers)
    call ch_evalexpr(server.ch, {'method': 'shutdown'}, {'timeout': 200})
    call s:Notify(server, 'exit', {})
    call job_stop(server.job)
  endfor
endfunction

function! lsp#Restart() abort
  call lsp#Stop()
  let s:failed = {}
  " Once the servers have exited; other buffers attach again on BufEnter
  call timer_start(500, {-> lsp#Start()})
endfunction

augroup lsp_exit
  autocmd!
  autocmd VimLeavePre * call lsp#Stop()
augroup END



" Document sync ----------------------------------------------------------------
function! s:Text(buf) abort
  return join(getbufline(a:buf, 1, '$'), "\n") . "\n"
endfunction

function! s:Open(server, buf) abort
  let a:server.bufs[a:buf] = getbufvar(a:buf, 'changedtick')
  call s:Notify(a:server, 'textDocument/didOpen', {'textDocument': {
        \ 'uri': s:Uri(bufname(a:buf)), 'version': a:server.bufs[a:buf],
        \ 'languageId': getbufvar(a:buf, 'lsp_lang'), 'text': s:Text(a:buf)}})
endfunction

" Send the buffer's text if it changed since it was last sent
function! s:Sync(buf) abort
  call timer_stop(get(s:timers, a:buf, -1))
  let server = s:Server(a:buf)
  let tick = getbufvar(a:buf, 'changedtick')
  if empty(server) || get(server.bufs, a:buf, tick) == tick
    return
  endif
  let server.bufs[a:buf] = tick
  call s:Notify(server, 'textDocument/didChange', {
        \ 'textDocument': {'uri': s:Uri(bufname(a:buf)), 'version': tick},
        \ 'contentChanges': [{'text': s:Text(a:buf)}]})
endfunction

function! s:Schedule(buf) abort
  let buf = a:buf
  call timer_stop(get(s:timers, buf, -1))
  let s:timers[buf] = timer_start(300, {-> s:Sync(buf)})
endfunction

function! s:Saved(buf) abort
  let server = s:Server(a:buf)
  if !empty(server) && has_key(server.bufs, a:buf)
    call s:Sync(a:buf)
    call s:Notify(server, 'textDocument/didSave',
          \ {'textDocument': s:Doc(a:buf)})
  endif
endfunction

function! s:Close(buf) abort
  let server = s:Server(a:buf)
  if !empty(server) && has_key(server.bufs, a:buf)
    call remove(server.bufs, a:buf)
    call s:Notify(server, 'textDocument/didClose',
          \ {'textDocument': s:Doc(a:buf)})
  endif
  call filter(s:diags, {buf -> buf != a:buf})
  call filter(s:deferred, {buf -> buf != a:buf})
endfunction



" Edits ------------------------------------------------------------------------
" Apply TextEdits to a loaded buffer, last one first so that the positions
" of the others stay valid. The result is sent to the server right away:
" TextChanged only fires for the current buffer.
function! s:ApplyEdits(server, buf, edits) abort
  let edits = map(copy(a:edits),
        \ {i, e -> [e.range.start.line, e.range.start.character, i, e]})
  call sort(edits, {a, b -> a[0] != b[0] ? b[0] - a[0]
        \ : a[1] != b[1] ? b[1] - a[1] : b[2] - a[2]})
  for item in edits
    let range = item[3].range
    let total = getbufinfo(a:buf)[0].linecount
    let [sl, el] = [range.start.line + 1, range.end.line + 1]
    let first = get(getbufline(a:buf, sl), 0, '')
    let last = get(getbufline(a:buf, el), 0, '')
    let head = strpart(first, 0, s:Col(a:server, first,
          \ range.start.character) - 1)
    let tail = strpart(last, s:Col(a:server, last, range.end.character) - 1)
    let new = split(head . substitute(item[3].newText, "\r", '', 'g') . tail,
          \ "\n", 1)
    " A range ending past the last line ends after its line break
    let past = el > total
    if past && len(new) > 1 && new[-1] ==# ''
      call remove(new, -1)
    endif
    if sl > total
      call appendbufline(a:buf, total, new)
      continue
    endif
    if el > sl
      call deletebufline(a:buf, sl + 1, min([el, total]))
    endif
    if past && new ==# [''] && sl > 1
      call deletebufline(a:buf, sl)
    else
      call setbufline(a:buf, sl, new[0])
      call appendbufline(a:buf, sl, new[1:])
    endif
  endfor
  call s:Sync(a:buf)
endfunction

" Apply a WorkspaceEdit; other files are loaded as (unsaved) buffers
function! s:ApplyWorkspaceEdit(server, edit) abort
  let changes = []
  for change in get(a:edit, 'documentChanges', [])
    if has_key(change, 'edits')
      call add(changes, [change.textDocument.uri, change.edits])
    endif
  endfor
  if empty(changes)
    let changes = items(get(a:edit, 'changes', {}))
  endif
  let total = 0
  for [uri, edits] in changes
    let buf = bufadd(s:Path(uri))
    call bufload(buf)
    call setbufvar(buf, '&buflisted', 1)
    call s:ApplyEdits(a:server, buf, edits)
    let total += len(edits)
  endfor
  call s:Echo(printf('%d edit(s) in %d file(s)', total, len(changes)))
endfunction



" Diagnostics ------------------------------------------------------------------
function! s:OnDiagnostics(server, params) abort
  let buf = bufnr(s:Path(get(a:params, 'uri', '')))
  if buf < 0 || !bufloaded(buf)
    return
  endif
  let diags = []
  for d in get(a:params, 'diagnostics', [])
    let [sl, el] = [d.range.start.line + 1, d.range.end.line + 1]
    call add(diags, {'lnum': sl, 'end_lnum': el,
          \ 'col': s:Col(a:server, get(getbufline(buf, sl), 0, ''),
          \   d.range.start.character),
          \ 'end_col': s:Col(a:server, get(getbufline(buf, el), 0, ''),
          \   d.range.end.character),
          \ 'severity': get(d, 'severity', 1), 'text': d.message, 'raw': d})
  endfor
  call sort(diags, {a, b -> a.lnum != b.lnum ? a.lnum - b.lnum
        \ : a.severity != b.severity ? a.severity - b.severity
        \ : a.col - b.col})
  " Like the Neovim config, don't update what is shown while typing
  if buf == bufnr('%') && mode() =~# '^[iR]'
    let s:deferred[buf] = diags
  else
    call s:SetDiagnostics(buf, diags)
  endif
endfunction

function! s:ShowDeferred(buf) abort
  if has_key(s:deferred, a:buf)
    call s:SetDiagnostics(a:buf, remove(s:deferred, a:buf))
  endif
endfunction

function! s:SetDiagnostics(buf, diags) abort
  let s:diags[a:buf] = a:diags
  call sign_unplace('lsp', {'buffer': a:buf})
  if !bufloaded(a:buf)
    return
  endif
  call prop_remove({'types': s:prop_types, 'bufnr': a:buf, 'all': 1})
  let lines = {}
  for d in a:diags
    let name = 'Lsp' . s:severity[d.severity - 1]
    " prop_add() fails if the buffer changed under the diagnostic
    try
      call prop_add(d.lnum, d.col, {'bufnr': a:buf, 'type': name . 'Under',
            \ 'end_lnum': d.end_lnum, 'end_col': d.end_col
            \   + (d.lnum == d.end_lnum && d.col == d.end_col)})
    catch /^Vim\%((\a\+)\)\=:E/
    endtry
    " One sign and one message per line: the most severe (sorted first)
    if has_key(lines, d.lnum)
      continue
    endif
    let lines[d.lnum] = 1
    call sign_place(0, 'lsp', name, a:buf, {'lnum': d.lnum, 'priority': 10})
    if d.severity < 4
      try
        call prop_add(d.lnum, 0, {'bufnr': a:buf, 'type': name . 'Text',
              \ 'text': '    ● ' . split(d.text . ' ', "\n")[0],
              \ 'text_align': 'after', 'text_wrap': 'truncate'})
      catch /^Vim\%((\a\+)\)\=:E/
      endtry
    endif
  endfor
endfunction

function! lsp#LineDiagnostics() abort
  let diags = filter(copy(get(s:diags, bufnr('%'), [])),
        \ {_, d -> d.lnum <= line('.') && d.end_lnum >= line('.')})
  if empty(diags)
    call s:Echo('no diagnostics on this line')
  endif
  for d in diags
    execute 'echohl Lsp' . s:severity[d.severity - 1] . 'Text'
    echo d.text
  endfor
  echohl None
endfunction

function! lsp#NextDiagnostic(dir) abort
  " In column order (s:diags has the most severe one of a line first)
  let diags = sort(copy(get(s:diags, bufnr('%'), [])),
        \ {a, b -> a.lnum != b.lnum ? a.lnum - b.lnum : a.col - b.col})
  let [l, c] = [line('.'), col('.')]
  let after = filter(copy(diags),
        \ {_, d -> d.lnum > l || (d.lnum == l && d.col > c)})
  let before = filter(copy(diags),
        \ {_, d -> d.lnum < l || (d.lnum == l && d.col < c)})
  " Wrap around the end of the buffer
  let d = a:dir > 0 ? get(after + diags, 0, {}) : get(diags + before, -1, {})
  if empty(d)
    return s:Echo('no diagnostics')
  endif
  normal! m'
  call cursor(d.lnum, d.col)
  normal! zv
  execute 'echohl Lsp' . s:severity[d.severity - 1] . 'Text'
  echo strcharpart(split(d.text . ' ', "\n")[0], 0, &columns - 15)
  echohl None
endfunction

function! lsp#Diagnostics() abort
  let buf = bufnr('%')
  let items = map(copy(get(s:diags, buf, [])), {_, d -> {'bufnr': buf,
        \ 'lnum': d.lnum, 'col': d.col, 'text': d.text,
        \ 'type': 'EWIN'[d.severity - 1]}})
  if empty(items)
    return s:Echo('no diagnostics')
  endif
  call setloclist(0, [], ' ', {'title': 'LSP diagnostics', 'items': items})
  lopen
endfunction



" Navigation -------------------------------------------------------------------
" A quickfix item for a Location or LocationLink
function! s:Item(server, loc) abort
  let path = s:Path(get(a:loc, 'uri', get(a:loc, 'targetUri', '')))
  let range = get(a:loc, 'targetSelectionRange', get(a:loc, 'range', {}))
  let lnum = range.start.line + 1
  let text = s:LineText(path, lnum)
  return {'filename': path, 'lnum': lnum, 'text': trim(text),
        \ 'col': s:Col(a:server, text, range.start.character)}
endfunction

" Jump to a single location, list several in the quickfix window
function! s:OnLocations(title, server, result) abort
  let locs = type(a:result) == v:t_dict ? [a:result]
        \ : type(a:result) == v:t_list ? a:result : []
  let items = map(copy(locs), {_, loc -> s:Item(a:server, loc)})
  if empty(items)
    call s:Echo('no ' . a:title . ' found')
  elseif len(items) == 1
    normal! m'
    if items[0].filename !=# expand('%:p')
      execute 'edit' fnameescape(fnamemodify(items[0].filename, ':~:.'))
    endif
    call cursor(items[0].lnum, items[0].col)
    normal! zv
  else
    call setqflist([], ' ', {'title': 'LSP ' . a:title, 'items': items})
    botright copen
  endif
endfunction

function! lsp#Jump(what) abort
  call s:Call('textDocument/' . a:what, function('s:Here'),
        \ function('s:OnLocations', [a:what]))
endfunction

function! lsp#References() abort
  call s:Call('textDocument/references', {server -> extend(s:Here(server),
        \ {'context': {'includeDeclaration': v:true}})},
        \ function('s:OnLocations', ['references']))
endfunction

" DocumentSymbols (a tree) or SymbolInformation (flat) as location list items
function! s:SymbolItems(server, symbols, depth) abort
  let items = []
  for s in a:symbols
    let range = has_key(s, 'location') ? s.location.range : s.selectionRange
    let lnum = range.start.line + 1
    call add(items, {'bufnr': bufnr('%'), 'lnum': lnum,
          \ 'col': s:Col(a:server, getline(lnum), range.start.character),
          \ 'text': repeat('  ', a:depth)
          \   . get(s:symbol_kinds, get(s, 'kind', 0) - 1, '') . ' ' . s.name})
    call extend(items,
          \ s:SymbolItems(a:server, get(s, 'children', []), a:depth + 1))
  endfor
  return items
endfunction

function! s:OnSymbols(server, result) abort
  if type(a:result) != v:t_list || empty(a:result)
    return s:Echo('no symbols')
  endif
  call setloclist(0, [], ' ', {'title': 'LSP symbols',
        \ 'items': s:SymbolItems(a:server, a:result, 0)})
  lopen
endfunction

function! lsp#Symbols() abort
  call s:Call('textDocument/documentSymbol',
        \ {-> {'textDocument': s:Doc()}}, function('s:OnSymbols'))
endfunction

function! s:OnHeader(server, result) abort
  if type(a:result) != v:t_string || a:result ==# ''
    return s:Echo('no matching source/header')
  endif
  execute 'edit' fnameescape(fnamemodify(s:Path(a:result), ':~:.'))
endfunction

function! lsp#SwitchHeader() abort
  call s:Call('textDocument/switchSourceHeader', {-> s:Doc()},
        \ function('s:OnHeader'))
endfunction



" Hover and signature help -----------------------------------------------------
" MarkupContent, a MarkedString or a List of them, as text
function! s:Markup(content) abort
  if type(a:content) == v:t_list
    return join(map(copy(a:content), {_, c -> s:Markup(c)}), "\n\n")
  elseif type(a:content) == v:t_dict
    return has_key(a:content, 'language')
          \ ? '```' . a:content.language . "\n" . a:content.value . "\n```"
          \ : get(a:content, 'value', '')
  endif
  return type(a:content) == v:t_string ? a:content : ''
endfunction

" Show lines in a preview window along the bottom; it closes when the
" cursor moves (or with <C-w>z); <C-w>P goes into it
function! s:Preview(lines) abort
  silent! pclose
  let win = win_getid()
  execute 'silent botright' min([len(a:lines), 15]) . 'new'
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  setlocal previewwindow winfixheight nonumber norelativenumber
  setlocal signcolumn=no filetype=markdown
  setlocal nospell wrap
  call setline(1, a:lines)
  setlocal nomodifiable
  nnoremap <buffer> <silent> q :close<CR>
  call win_gotoid(win)
  let s:preview_pos = [bufnr('%')] + getcurpos()
  augroup lsp_preview
    autocmd!
    autocmd CursorMoved,InsertEnter * call s:ClosePreview()
  augroup END
endfunction

" Close the preview once the cursor is somewhere else (CursorMoved also
" fires on coming back from the new window), unless it went into it
function! s:ClosePreview() abort
  if &previewwindow
        \ || (mode() ==# 'n' && [bufnr('%')] + getcurpos() == s:preview_pos)
    return
  endif
  silent! pclose
  autocmd! lsp_preview
endfunction

function! s:OnHover(server, result) abort
  let text = type(a:result) == v:t_dict
        \ ? s:Markup(get(a:result, 'contents', '')) : ''
  let lines = split(trim(text, "\n"), "\n")
  if empty(lines)
    return s:Echo('no information')
  endif
  call s:Preview(lines)
endfunction

function! lsp#Hover() abort
  call s:Call('textDocument/hover', function('s:Here'), function('s:OnHover'))
endfunction

function! s:OnSignature(server, result) abort
  let sigs = type(a:result) == v:t_dict ? get(a:result, 'signatures', []) : []
  if empty(sigs)
    return s:Echo('no signature')
  endif
  let active = get(a:result, 'activeSignature', 0)
  let sig = get(sigs, type(active) == v:t_number ? active : 0, sigs[0])
  echo strcharpart(split(sig.label . ' ', "\n")[0], 0, &columns - 15)
endfunction

function! lsp#Signature() abort
  call s:Call('textDocument/signatureHelp', function('s:Here'),
        \ function('s:OnSignature'))
endfunction



" Rename, format, code actions -------------------------------------------------
function! s:OnRename(server, result) abort
  if type(a:result) != v:t_dict
    return s:Echo('nothing to rename')
  endif
  call s:ApplyWorkspaceEdit(a:server, a:result)
endfunction

function! lsp#Rename() abort
  let old = expand('<cword>')
  let new = input('New name: ', old)
  if new ==# '' || new ==# old
    return
  endif
  call s:Call('textDocument/rename',
        \ {server -> extend(s:Here(server), {'newName': new})},
        \ function('s:OnRename'))
endfunction

function! s:OnFormat(buf, server, result) abort
  if type(a:result) != v:t_list || empty(a:result) || !bufloaded(a:buf)
    return s:Echo('nothing to format')
  endif
  let view = winsaveview()
  call s:ApplyEdits(a:server, a:buf, a:result)
  call winrestview(view)
  call s:Echo('formatted')
endfunction

function! lsp#Format() abort
  let visual = mode() =~# "^[vV\<C-v>]"
  let options = {'tabSize': shiftwidth(),
        \ 'insertSpaces': &expandtab ? v:true : v:false}
  call s:Call('textDocument/' . (visual ? 'rangeFormatting' : 'formatting'),
        \ {server -> extend({'textDocument': s:Doc(), 'options': options},
        \   visual ? {'range': s:Range(server)} : {})},
        \ function('s:OnFormat', [bufnr('%')]))
endfunction

function! s:OnActions(server, result) abort
  let actions = type(a:result) == v:t_list ? a:result : []
  if empty(actions)
    return s:Echo('no code actions')
  endif
  let choice = inputlist(['Code actions:']
        \ + map(copy(actions), {i, a -> printf('%2d. %s', i + 1, a.title)}))
  if choice < 1 || choice > len(actions)
    return
  endif
  let action = actions[choice - 1]
  if type(get(action, 'edit', 0)) == v:t_dict
    call s:ApplyWorkspaceEdit(a:server, action.edit)
  endif
  " Either a CodeAction with a Command inside, or a bare Command
  let command = get(action, 'command', '')
  let command = type(command) == v:t_dict ? command
        \ : command ==# '' ? {} : action
  if !empty(command)
    call s:Request(a:server, 'workspace/executeCommand',
          \ {'command': command.command,
          \ 'arguments': get(command, 'arguments', [])}, {-> 0})
  endif
endfunction

function! s:ActionParams(only, server) abort
  let range = s:Range(a:server)
  let diags = filter(copy(get(s:diags, bufnr('%'), [])),
        \ {_, d -> d.lnum <= range.end.line + 1
        \   && d.end_lnum >= range.start.line + 1})
  return {'textDocument': s:Doc(), 'range': range, 'context': extend(
        \ {'diagnostics': map(diags, {_, d -> d.raw})}, a:only)}
endfunction

" Code actions for the cursor or selection; a:1 limits them to a kind
function! lsp#CodeAction(...) abort
  call s:Call('textDocument/codeAction',
        \ function('s:ActionParams', [a:0 ? {'only': [a:1]} : {}]),
        \ function('s:OnActions'))
endfunction



" Completion -------------------------------------------------------------------
" Used as 'omnifunc' and as a 'complete' source. The server is asked on the
" first call, while the text before the cursor is still in the buffer.
let s:items = []

function! lsp#Complete(findstart, base) abort
  if a:findstart
    let s:items = []
    let server = s:Server(bufnr('%'))
    if !empty(server) && server.ready
      call s:Sync(bufnr('%'))
      let reply = ch_evalexpr(server.ch, {'method': 'textDocument/completion',
            \ 'params': s:Here(server)}, {'timeout': 500})
      let result = type(reply) == v:t_dict ? get(reply, 'result', []) : []
      let items = type(result) == v:t_dict ? get(result, 'items', [])
            \ : type(result) == v:t_list ? result : []
      let s:items = sort(copy(items), {a, b -> get(a, 'sortText', a.label)
            \ ># get(b, 'sortText', b.label) ? 1 : -1})
    endif
    return match(strpart(getline('.'), 0, col('.') - 1), '\k*$')
  endif

  let fuzzy = &completeopt =~# 'fuzzy'
  let matches = []
  for i in range(len(s:items))
    let item = s:items[i]
    let edit = get(item, 'textEdit', {})
    let word = type(edit) == v:t_dict && has_key(edit, 'newText')
          \ ? edit.newText : get(item, 'insertText', '')
    let word = word ==# '' ? trim(item.label) : word
    if a:base !=# '' && (fuzzy ? empty(matchfuzzy([word], a:base))
          \ : stridx(tolower(word), tolower(a:base)) != 0)
      continue
    endif
    " user_data: finds the item again when it is accepted (s:CompleteDone)
    call add(matches, {'word': word, 'abbr': trim(item.label), 'icase': 1,
          \ 'dup': 1, 'user_data': json_encode({'lsp_item': i}),
          \ 'kind': get(s:item_kinds, get(item, 'kind', 0) - 1, ''),
          \ 'menu': strcharpart(get(item, 'detail', ''), 0, 40)})
  endfor
  return matches
endfunction

" 'autocomplete' only reacts to keyword characters: open the menu after
" member access too ('.', '::', '->'), where the server asks for that
function! s:TriggerCompletion() abort
  let provider = get(get(s:Server(bufnr('%')), 'caps', {}),
        \ 'completionProvider', {})
  let chars = type(provider) == v:t_dict
        \ ? get(provider, 'triggerCharacters', []) : []
  if !pumvisible() && index(['.', ':', '>'], v:char) >= 0
        \ && index(chars, v:char) >= 0
    call feedkeys("\<C-x>\<C-o>", 'n')
  endif
endfunction

" Extra edits of the accepted item, such as adding an import. Servers may
" only send them on request (completionItem/resolve).
function! s:CompleteDone() abort
  let data = get(v:completed_item, 'user_data', '')
  let server = s:Server(bufnr('%'))
  if type(data) != v:t_string || data !~# '^{"lsp_item"' || empty(server)
    return
  endif
  let item = get(s:items, json_decode(data).lsp_item, {})
  let buf = bufnr('%')
  if !empty(get(item, 'additionalTextEdits', []))
    call s:ExtraEdits(buf, server, item)
  elseif has_key(item, 'data')
    " ('data' is what the server resolves the item by; rust-analyzer
    " resolves imports even when it announces no resolveProvider)
    call s:Request(server, 'completionItem/resolve', item,
          \ {result -> s:ExtraEdits(buf, server, result)})
  endif
endfunction

function! s:ExtraEdits(buf, server, item) abort
  let edits = type(a:item) == v:t_dict
        \ ? get(a:item, 'additionalTextEdits', []) : []
  if type(edits) != v:t_list || empty(edits) || !bufloaded(a:buf)
    return
  endif
  " The edits are usually above the cursor: keep it on its line
  let [lnum, col, total] = [line('.'), col('.'), line('$')]
  call s:ApplyEdits(a:server, a:buf, edits)
  if a:buf == bufnr('%')
    call cursor(lnum + line('$') - total, col)
  endif
endfunction
