""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: 
"     Author: 
"    Version: 
" CreateTime: 2019-03-22 13:48:44
" LastUpdate: 2019-03-22 13:48:44
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""

if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

function! lsp_lc#lsp_lc_config()
	"languageserver-client
	" \ 'sh': ['bash-language-server', 'start'],
	"\ 'go': ['gopls'],
	"\ 'go': ['go-langserver', '-gocodecompletion', '-logfile=/tmp/golangserver.log'],
    "\ 'go': ['bingo', '--mode', 'stdio', '--logfile', '/tmp/bingo.log', '-disable-func-snippet', '-maxparallelism', '4', '-cache-style', 'on-demand'],
    "\ 'rust': ['ra_lsp_server'],
    "\ 'rust': ['rls'],
    "\ 'cpp': ['clangd'],
	let g:LanguageClient_serverCommands = {
    \ 'rust': ['rls'],
	\ 'go': ['gopls', 'serve'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'cpp': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'objc': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'c': ['ccls', '--log-file=/tmp/cc.log'],
	\ 'lua': ['lua-lsp'],
	\ 'dockerfile': ['docker-langserver', '--stdio'],
	\ 'css': ['css-languageserver', '--stdio'],
	\ 'html': ['html-languageserver', '--stdio'],
	\ 'json': ['json-languageserver', '--stdio'],
	\ 'wxml': ['wxml-languageserver', '--stdio'],
	\ 'php': ['php-lsp'],
    \ }
	let g:LanguageClient_rootMarkers = {
        \ 'go': ['go.mod'],
        \ }
	let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
	let g:LanguageClient_settingsPath = $HOME . '/.config/nvim/setting.json'
	let g:LanguageClient_selectionUI = 'location-list'
	let g:LanguageClient_hoverPreview = 'Always'
	""let g:LanguageClient_completionPreferTextEdit = 1
	let g:LanguageClient_loggingFile = '/tmp/lsp-lc.log'
	""let g:LanguageClient_windowLogMessageLevel = 'Log'

	"nnoremap <F5> :call LanguageClient_contextMenu()<CR>
	" Or map each action separately
	nnoremap <silent> <m-h> :call LanguageClient#textDocument_hover()<CR>
	nnoremap <silent> <m-g> :call LanguageClient#textDocument_definition()<CR>
	nnoremap <silent> <m-r> :call LanguageClient#textDocument_rename()<CR>
	nnoremap <silent> <m-f> :call LanguageClient#textDocument_references()<CR>
	"nnoremap <silent> <m-s> :call LanguageClient#workspace_symbol()<CR>
	nnoremap <silent> <m-i> :call LanguageClient#textDocument_implementation()<CR>
	nnoremap <silent> <m-t> :call LanguageClient_textDocument_documentSymbol()<CR>
	nnoremap <silent> gq :call LanguageClient#textDocument_formatting()<CR>
endfunction
