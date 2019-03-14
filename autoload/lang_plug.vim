""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: MIT
"     Author: Cosson2017
"    Version: 0.5
" CreateTime: 2018-08-21 22:45:56
" LastUpdate: 2018-08-21 22:45:56
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""

if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

func lang_plug#add()
	"Plug 'prabirshrestha/vim-lsp'
	"Plug 'prabirshrestha/async.vim'
	"Plug 'majutsushi/tagbar'
	Plug 'cespare/vim-toml'
	Plug 'Shougo/echodoc.vim'
	"Plug 'Shougo/deoplete.nvim' 

	"""""""""""""""""""""
	"Plug 'roxma/nvim-yarp'
	"Plug 'ncm2/ncm2'
	"Plug 'ncm2/ncm2-bufword'
    "Plug 'ncm2/ncm2-path'
	"Plug 'ncm2/float-preview.nvim'
	"""""""""""""""""""""

	"Plug 'rust-lang/rust.vim'
	"Plug 'peterhoeg/vim-qml', {'for':['qml']}
	" Track the engine.
	"Plug 'SirVer/ultisnips'

    ""\ 'do': 'bash install.sh',
	"Plug 'Cosson2017/LanguageClient-neovim', {
    "\ 'branch': 'next',
    "\ }

	Plug 'prabirshrestha/async.vim'
	Plug 'prabirshrestha/vim-lsp'

	Plug 'Cosson2017/nvim-completor'
	"Plug 'Cosson2017/nvim-completor-lc'
	Plug 'Cosson2017/nvim-completor-vim-lsp'

	"c family highlight
	"call dein#add('arakashic/chromatica.nvim' ", {'for':['cpp', 'h', 'hpp', 'c']}
	"call dein#add('rhysd/vim-clang-format', {'for':['cpp', 'h', 'hpp', 'c']}

	"wx program
	"call dein#add('chemzqm/wxapp.vim')
	"tagbar 
	"call dein#add('Cosson2017/neo-debuger')
endfunc

func lang_plug#config()
	"chromatica
	"au FileType h,hpp,c,cpp ChromaticaStart
	let g:chromatica#enable_at_startup = 0
	let g:chromatica#highlight_feature_level = 1
	let g:chromatica#responsive_mode=1
	let g:chromatica#delay_ms = 50
	let g:chromatica#libclang_path = '/usr/lib/libclang.so'

	"echodoc
	let g:echodoc_enable_at_startup = 1

	" deoplete.
	let g:deoplete#enable_at_startup = 1
	"call deoplete#custom#option('ignore_sources', {'_': ['buffer', 'around', 'member', 'omni', 'tag']})

	"""ncm2
	"autocmd BufEnter * call ncm2#enable_for_buffer()
	"set completeopt=noinsert,menuone,noselect
	"set shortmess+=c
	"inoremap <c-c> <ESC>
	"inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
	"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    "inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	"let g:ncm2#matcher = 'substrfuzzy'

	" float-preview.nvim
	"set completeopt+=preview
	
"	"
"	"languageserver-client
"	" \ 'sh': ['bash-language-server', 'start'],
"	"\ 'go': ['gopls'],
"	"\ 'go': ['go-langserver', '-gocodecompletion', '-logfile=/tmp/golangserver.log'],
"    "\ 'go': ['bingo', '--mode', 'stdio', '--logfile', '/tmp/bingo.log', '-disable-func-snippet', '-maxparallelism', '4', '-cache-style', 'on-demand'],
"    "\ 'rust': ['ra_lsp_server'],
"    "\ 'rust': ['rls'],
"	let g:LanguageClient_serverCommands = {
"    \ 'rust': ['rls'],
"    \ 'go': ['bingo', '--mode', 'stdio', '--logfile', '/tmp/bingo.log', '-disable-func-snippet', '-maxparallelism', '4', '-cache-style', 'on-demand'],
"    \ 'javascript': ['javascript-typescript-stdio'],
"    \ 'python': ['/usr/local/bin/pyls'],
"    \ 'cpp': ['ccls', '--log-file=/tmp/cc.log'],
"    \ 'objc': ['ccls', '--log-file=/tmp/cc.log'],
"    \ 'c': ['ccls', '--log-file=/tmp/cc.log'],
"	\ 'lua': ['lua-lsp'],
"	\ 'dockerfile': ['docker-langserver', '--stdio'],
"	\ 'css': ['css-languageserver', '--stdio'],
"	\ 'html': ['html-languageserver', '--stdio'],
"	\ 'json': ['json-languageserver', '--stdio'],
"	\ 'wxml': ['wxml-languageserver', '--stdio'],
"	\ 'php': ['php-lsp'],
"    \ }
"	let g:LanguageClient_rootMarkers = {
"        \ 'go': ['go.mod'],
"        \ }
"	let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
"	let g:LanguageClient_settingsPath = $HOME . '/.config/nvim/setting.json'
"	let g:LanguageClient_selectionUI = 'location-list'
"	let g:LanguageClient_hoverPreview = 'Always'
"	""let g:LanguageClient_completionPreferTextEdit = 1
"	let g:LanguageClient_loggingFile = '/tmp/lsp-lc.log'
"	""let g:LanguageClient_windowLogMessageLevel = 'Log'
"
"	"nnoremap <F5> :call LanguageClient_contextMenu()<CR>
"	" Or map each action separately
"	nnoremap <silent> <m-h> :call LanguageClient#textDocument_hover()<CR>
"	nnoremap <silent> <m-g> :call LanguageClient#textDocument_definition()<CR>
"	nnoremap <silent> <m-r> :call LanguageClient#textDocument_rename()<CR>
"	nnoremap <silent> <m-f> :call LanguageClient#textDocument_references()<CR>
"	nnoremap <silent> <m-s> :call LanguageClient#workspace_symbol()<CR>
"	nnoremap <silent> <m-i> :call LanguageClient#textDocument_implementation()<CR>
"	"nnoremap <silent> <m-t> :call LanguageClient_textDocument_documentSymbol()<CR>
"	nnoremap <silent> gq :call LanguageClient#textDocument_formatting()<CR>
"	"nnoremap <silent> <m-j> :LspNextError<CR>
"	"nnoremap <silent> <m-k> :LspPreviousError<CR>
	
	if executable('bingo')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'bingo',
        \ 'cmd': {server_info->['bingo', '-mode', 'stdio', '--logfile', '/tmp/bingo.log', '-disable-func-snippet', '-maxparallelism', '4', '-cache-style', 'on-demand']},
        \ 'whitelist': ['go'],
        \ })
	endif

	"
"	\ 'dockerfile': ['docker-langserver', '--stdio'],
"	\ 'css': ['css-languageserver', '--stdio'],
"	\ 'html': ['html-languageserver', '--stdio'],
"	\ 'json': ['json-languageserver', '--stdio'],
"	\ 'wxml': ['wxml-languageserver', '--stdio'],


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

	let g:lsp_signs_enabled = 1         " enable signs
	let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
	let g:lsp_virtual_text_enabled = 1
	let g:lsp_signs_error = {'text': '✗'}
	let g:lsp_signs_warning = {'text': '‼'}

	autocmd FileType * setlocal omnifunc=lsp#complete

	nnoremap <silent> <m-f> :LspReferences<cr>
	nnoremap <silent> <m-j> :LspNextError<cr>
	nnoremap <silent> <m-k> :LspPreviousError<cr>
	nnoremap <silent> <m-r> :LspRename<cr>
	nnoremap <silent> <m-g> :LspDefinition<cr>
	nnoremap <silent> <m-s> :LspDocumentSymbol<cr>
	nnoremap <silent> <m-h> :LspHover<cr>

	" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<c-k>"
"let g:UltiSnipsJumpForwardTrigger="<c-k>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
endfunc
