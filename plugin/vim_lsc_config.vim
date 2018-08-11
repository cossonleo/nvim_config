""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: 
"     Author: 
"    Version: 
" CreateTime: 2018-08-11 18:08:42
" LastUpdate: 2018-08-11 18:08:42
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""

"vim-lsc
if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

let need_load = get(g:, "load_vim_lsc", 0)
if need_load == 0
	finish
endif

au BufRead,BufNewFile *.ts,javascript.jsx, *.js	set filetype=javascript
au BufRead,BufNewFile *.wxml	set filetype=wxml
let g:lsc_preview_split_direction = 'below'
let g:lsc_enable_autocomplete = v:false
let g:lsc_auto_map = v:true " Use defaults
" ... or set only the keys you want mapped, defaults are:
let g:lsc_auto_map = {
    \ 'GoToDefinition': '<A-g>',
    \ 'FindReferences': '<A-f>',
    \ 'NextReference': '<A-n>',
    \ 'PreviousReference': '<A-N>',
    \ 'FindImplementations': '<A-i>',
    \ 'FindCodeActions': '<A-a>',
    \ 'DocumentSymbol': '',
    \ 'WorkspaceSymbol': '',
    \ 'ShowHover': '<A-h>',
    \ 'Completion': 'completefunc',
    \}


"	\ 'lua': {
"	\	'command': 'lua-lsp',
"    \   'enabled': v:true,
"	\	'message_hooks': {
"	\		'initialization_options': { 'debugMode': 'false' },
"	\	},
"	\},
let g:lsc_server_commands = {
	\ 'go': 'go-langserver -gocodecompletion -logfile=/tmp/golangserver.log',
	\ 'cpp': 'ccls',
	\ 'rust': 'rustup run stable rls',
	\ 'dockerfile': 'docker-langserver --stdio',
	\ 'lua': 'lua-lsp',
	\ 'javascript': "javascript-typescript-stdio",
	\ 'wxml': 'wxml-languageserver',
	\ 'json': 'json-languageserver',
	\ 'css': 'css-languageserver --stdio',
	\ 'html': 'html-languageserver --stdio',
	\ 'python': 'pyls --log-file=/tmp/pyls.log',
	\ 'java': 'java-lsp',
\}
