""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: 
"     Author: 
"    Version: 
" CreateTime: 2018-08-09 17:11:11
" LastUpdate: 2018-08-09 17:11:11
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""
if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

let need_load = get(g:, "load_vim_lsp", 0)
if need_load == 0
	finish
endif

"vim-lsp
au BufRead,BufNewFile *.ts,javascript.jsx, *.js	set filetype=javascript
au BufRead,BufNewFile *.h set filetype=c
au BufRead,BufNewFile *.cc,*.hpp set filetype=cpp
let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_preview_keep_focus = 1

let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('/tmp/vim-lsp.log')

nnoremap <silent> <m-]> :LspDefinition<CR>
nnoremap <silent> <m-g> :LspDefinition<CR>
nnoremap <silent> <m-h> :LspHover<CR>
nnoremap <silent> <m-f> :LspReferences<CR>
nnoremap <silent> <m-s> :LspDocumentSymbol<CR>
nnoremap <silent> <m-r> :LspRename<CR>
nnoremap <silent> <m-i> :LspImplement<CR>
nnoremap <silent> <m-j> :LspNextError<CR>
nnoremap <silent> <m-k> :LspPreviousError<CR>
nnoremap <silent> gq :LspDocumentFormat<CR>

if executable('go-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'go-langserver',
		\ 'cmd': {server_info->['go-langserver', '-gocodecompletion', '-logfile=/tmp/golangserver.log', '-diagnostics', '-trace']},
        \ 'whitelist': ['go'],
        \ })
endif

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'whitelist': ['c', 'cpp'],
        \ })
endif

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rust-rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif

if executable('lua-lsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'lua-lsp',
        \ 'cmd': {server_info->['lua-lsp']},
        \ 'root_uri': {server_info->lsp#utils#get_default_root_uri()},
		\ 'initialization_options': { 'debugMode': 'false' },
        \ 'whitelist': ['lua'],
        \ })
endif

if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls', '--log-file=/tmp/pyls.log']},
        \ 'whitelist': ['python'],
        \ })
endif

if executable('docker-langserver')
	au User lsp_setup call lsp#register_server({
		\ 'name': 'docker-langserver',
		\ 'cmd': {server_info->['docker-langserver', '--stdio']},
		\ 'whitelist': ['dockerfile'],
		\ })
endif

if executable('javascript-typescript-stdio')
	    au User lsp_setup call lsp#register_server({
	            \ 'name': 'javascript-typescript-stdio',
	            \ 'cmd': {server_info->[&shell, &shellcmdflag, 'javascript-typescript-stdio']},
	            \ 'whitelist': ['javascript', 'typescript'],
	            \ })
endif

if executable('css-languageserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'css-languageserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
        \ 'whitelist': ['css', 'less', 'sass'],
        \ })
endif

if executable('html-languageserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'html-languageserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'html-languageserver --stdio']},
        \ 'whitelist': ['htm', 'html'],
        \ })
endif

if executable('json-languageserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'json-languageserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'json-languageserver --stdio']},
        \ 'whitelist': ['json'],
        \ })
endif

if executable('wxml-languageserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'wxml-languageserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'wxml-languageserver --stdio']},
        \ 'whitelist': ['wxml'],
        \ })
endif

if executable('java-lsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'java-lsp',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'java-lsp']},
        \ 'whitelist': ['java'],
        \ })
endif
