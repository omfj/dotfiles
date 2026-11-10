" lsp.vim — a small language server client, part of the dotfiles' vimrc
" (follows its style guide). Uses Vim's built-in LSP channel mode; the client
" itself is in autoload/lsp.vim and is only loaded once a file with a server
" below is opened. No floating windows: hover opens a preview split, lists
" go to the quickfix/location list, messages to the command line.
"
" Keys mirror the Neovim config. They are global mappings that fall back to
" the built-in key in buffers without a server (buffer-local ones would
" make which.vim's triggers ambiguous).
"   gd gD gri grt  definition, declaration, implementation, type definition
"   grr gO         references, document symbols
"   K <C-k>        hover, signature help
"   grn            rename
"   gra <leader>ca code action (also visual), <leader>cA source action
"   <leader>cf     format (also visual)
"   <leader>cd     diagnostics on this line, ]d [d next/previous,
"   <leader>xx     all diagnostics in the location list
"   <leader>ch     switch source/header (clangd)
" :LspInfo, :LspStop and :LspRestart manage the servers.
scriptencoding utf-8
if exists('g:loaded_dotfiles_lsp') || !has('job') || !has('channel')
      \ || !has('textprop') || !exists('*strutf16len')
  finish
endif
let g:loaded_dotfiles_lsp = 1



" Servers ----------------------------------------------------------------------
" By filetype. 'cmds' are tried in order and the first installed one is used.
" 'root' are files that mark the project root, searched upwards from the
" file, most specific first. 'init' is sent as initializationOptions.
let s:rustup_ra = expand('~/.cargo/bin/rust-analyzer')
let s:clangd = {'name': 'clangd', 'cmds': [['clangd', '--background-index',
      \ '--clang-tidy', '--header-insertion=iwyu',
      \ '--completion-style=detailed', '--fallback-style=llvm']],
      \ 'root': ['compile_commands.json', 'compile_flags.txt', '.clangd',
      \ '.git'],
      \ 'init': {'completeUnimported': v:true, 'clangdFileStatus': v:true}}
let g:dotfiles_lsp = {
      \ 'rust': {'name': 'rust-analyzer', 'lang': 'rust',
      \   'cmds': [[s:rustup_ra], ['rust-analyzer']],
      \   'root': ['Cargo.lock', 'Cargo.toml', '.git'],
      \   'init': {'cargo': {'allFeatures': v:true},
      \     'check': {'command': 'clippy'},
      \     'imports': {'granularity': {'group': 'module'}, 'prefix': 'self'},
      \     'procMacro': {'enable': v:true}}},
      \ 'c': extend({'lang': 'c'}, s:clangd),
      \ 'cpp': extend({'lang': 'cpp'}, s:clangd),
      \ 'cs': {'name': 'csharp-ls', 'lang': 'csharp',
      \   'cmds': [['csharp-ls'], ['OmniSharp', '-lsp'], ['omnisharp', '-lsp']],
      \   'root': ['*.sln', '*.slnx', '*.csproj', '.git'], 'init': {}}}

augroup dotfiles_lsp
  autocmd!
  " BufEnter as well: picks up buffers again after :LspRestart
  autocmd FileType,BufEnter * if has_key(g:dotfiles_lsp, &filetype)
        \ |   call lsp#Start()
        \ | endif
augroup END

command! -bar LspInfo call lsp#Info()
command! -bar LspStop call lsp#Stop()
command! -bar LspRestart call lsp#Restart()



" Keymaps ----------------------------------------------------------------------
" Map lhs to lsp#{call} in buffers with a server, else to the fallback keys
function! s:Map(modes, lhs, call, fallback) abort
  for mode in split(a:modes, '\zs')
    execute mode . 'noremap <expr>' a:lhs "get(b:, 'lsp', '') ==# '' ?"
          \ string(a:fallback) ':' string('<Cmd>call lsp#' . a:call . '<CR>')
  endfor
endfunction

call s:Map('n', 'gd', "Jump('definition')", 'gd')
call s:Map('n', 'gD', "Jump('declaration')", 'gD')
call s:Map('n', 'gri', "Jump('implementation')", 'gri')
call s:Map('n', 'grt', "Jump('typeDefinition')", 'grt')
call s:Map('n', 'grr', 'References()', 'grr')
call s:Map('n', 'gO', 'Symbols()', 'gO')
call s:Map('n', 'K', 'Hover()', 'K')
call s:Map('n', '<C-k>', 'Signature()', '<C-w>k')
call s:Map('n', 'grn', 'Rename()', 'grn')
call s:Map('nx', 'gra', 'CodeAction()', 'gra')
call s:Map('nx', '<leader>ca', 'CodeAction()', '')
call s:Map('n', '<leader>cA', "CodeAction('source')", '')
call s:Map('nx', '<leader>cf', 'Format()', '')
call s:Map('n', '<leader>cd', 'LineDiagnostics()', '')
call s:Map('n', '<leader>ch', 'SwitchHeader()', '')
call s:Map('n', '<leader>xx', 'Diagnostics()', '')
call s:Map('n', ']d', 'NextDiagnostic(1)', ']d')
call s:Map('n', '[d', 'NextDiagnostic(-1)', '[d')
