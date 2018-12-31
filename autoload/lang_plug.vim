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
	Plug 'Shougo/echodoc.vim'
	Plug 'Cosson2017/nvim-completor'
	"Plug 'peterhoeg/vim-qml', {'for':['qml']}
	" Track the engine.
	"Plug 'SirVer/ultisnips'

    "\ 'do': 'bash install.sh',
	Plug 'Cosson2017/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ }

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


	"nvim-completor
	let g:load_nvim_completor_lsp = 0
	let g:load_vim_lsp = 0
	let g:load_nvim_completor_languageclient_neovim = 1


	"languageserver-client
	" \ 'sh': ['bash-language-server', 'start'],
	"\ 'go': ['golsp'],
	"\ 'go': ['go-langserver', '-gocodecompletion', '-logfile=/tmp/golangserver.log'],
    "\ 'go': ['bingo', '--mode', 'stdio', '--logfile', '/tmp/lspserver.log','--trace', '--pprof', ':6060', '-enable-global-cache'],
    "\ 'go': ['bingo', '--mode', 'stdio', '--logfile', '/tmp/lspserver.log', '-disable-func-snippet'],
	let g:LanguageClient_serverCommands = {
    \ 'rust': ['rls'],
    \ 'go': ['bingo', '--mode', 'stdio', '--logfile', '/tmp/lspserver.log', '-disable-func-snippet'],
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
	"let g:LanguageClient_rootMarkers = {
    "    \ 'go': ['go.mod'],
    "    \ }
	let g:LanguageClient_loadSettings = 1 " Use an absolute configuration path if you want system-wide settings
	let g:LanguageClient_settingsPath = $HOME . '/.config/nvim/setting.json'
	let g:LanguageClient_selectionUI = 'location-list'
	let g:LanguageClient_hoverPreview = 'Always'
	let g:LanguageClient_completionPreferTextEdit = 1
	let g:LanguageClient_loggingFile = '/tmp/lsp-lc.log'

	"nnoremap <F5> :call LanguageClient_contextMenu()<CR>
	" Or map each action separately
	nnoremap <silent> <m-h> :call LanguageClient#textDocument_hover()<CR>
	nnoremap <silent> <m-g> :call LanguageClient#textDocument_definition()<CR>
	nnoremap <silent> <m-r> :call LanguageClient#textDocument_rename()<CR>
	nnoremap <silent> <m-f> :call LanguageClient#textDocument_references()<CR>
	nnoremap <silent> <m-s> :call LanguageClient#workspace_symbol()<CR>
	nnoremap <silent> <m-i> :call LanguageClient#textDocument_implementation()<CR>
	nnoremap <silent> gq :call LanguageClient#textDocument_formatting()<CR>
	"nnoremap <silent> <m-j> :LspNextError<CR>
	"nnoremap <silent> <m-k> :LspPreviousError<CR>

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<c-k>"
"let g:UltiSnipsJumpForwardTrigger="<c-k>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
endfunc
