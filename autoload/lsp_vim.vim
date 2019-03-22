""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: 
"     Author: 
"    Version: 
" CreateTime: 2019-03-22 13:48:53
" LastUpdate: 2019-03-22 13:48:53
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""

if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

function! lsp_vim#vim_lsp_config()
	" vim-lsp

	if executable('bingo')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'bingo',
        \ 'cmd': {server_info->['bingo', '-mode', 'stdio', '--logfile', '/tmp/bingo.log', '-disable-func-snippet', '-maxparallelism', '4', '-cache-style', 'on-demand']},
        \ 'whitelist': ['go'],
        \ })
	endif

	"if executable('ra_lsp_server')
    "au User lsp_setup call lsp#register_server({
    "    \ 'name': 'ra_lsp_server',
    "    \ 'cmd': {server_info->['ra_lsp_server']},
    "    \ 'whitelist': ['rust'],
    "    \ })
	"endif

	if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
	endif

	if executable('ccls')
		au User lsp_setup call lsp#register_server({
			\ 'name': 'ccls',
			\ 'cmd': {server_info->['ccls']},
			\ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
			\ 'initialization_options': {},
			\ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
			\ })
	endif

	if executable('lua-lsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'lua-lsp',
        \ 'cmd': {server_info->['lua-lsp']},
        \ 'whitelist': ['lua'],
        \ })
	endif

	if executable('javascript-typescript-stdio')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'javascript-typescript-stdio',
        \ 'cmd': {server_info->['javascript-typescript-stdio']},
        \ 'whitelist': ['javascript', 'typescript'],
        \ })
	endif

	if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ })
	endif

	if executable('php-lsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'php-lsp',
        \ 'cmd': {server_info->['php-lsp']},
        \ 'whitelist': ['php'],
        \ })
	endif

	let g:lsp_signs_enabled = 0         " enable signs
	let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
	let g:lsp_virtual_text_enabled = 1
	let g:lsp_signs_error = {'text': '✗'}
	let g:lsp_signs_warning = {'text': '‼'}
	let g:lsp_log_verbose= 0
	let g:lsp_log_file = '/tmp/lsp.log'

	autocmd FileType * setlocal omnifunc=lsp#complete
	nnoremap <silent> <m-f> :LspReferences<cr>
	nnoremap <silent> <m-j> :LspNextError<cr>
	nnoremap <silent> <m-k> :LspPreviousError<cr>
	nnoremap <silent> <m-r> :LspRename<cr>
	nnoremap <silent> <m-g> :LspDefinition<cr>
	nnoremap <silent> <m-s> :LspDocumentSymbol<cr>
	nnoremap <silent> <m-h> :LspHover<cr>
	nnoremap <silent> gq :LspDocumentFormat<CR>
endfunction
