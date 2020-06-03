""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: MIT
"     Author: Cosson2017
"    Version: 0..5
" CreateTime: 2018-08-21 22:02:23
" LastUpdate: 2018-08-21 22:02:23
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""

if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

func common_plug#add()
	Plug 'luochen1990/rainbow'
	Plug 'joshdick/onedark.vim'
	Plug 'machakann/vim-sandwich'
	Plug 'kshenoy/vim-signature'
	Plug 'voldikss/vim-floaterm'
	Plug 'terryma/vim-multiple-cursors'
	"Plug 'puremourning/vimspector'

	"Plug 'skywind3000/vim-tvision'

	Plug 'cespare/vim-toml', {'for': ['toml']}
	Plug 'peterhoeg/vim-qml', {'for':['qml']}

	"Plug 'tpope/vim-fugitive'
	Plug 'whiteinge/diffconflicts'
	Plug 'cossonleo/dirdiff.nvim'
	Plug 'cossonleo/neo-comment.nvim'
	Plug 'cossonleo/neo-smooth-scroll.nvim'

	Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
	Plug 'voldikss/vim-translator'
	Plug 'kyazdani42/nvim-tree.lua'
"	Plug 'kyazdani42/nvim-web-devicons' " for file icons
endfunc

function! s:leaderf_grep_cmd()
	let l:default_input = expand('<cword>')
	let l:cancel_return = "cancel_returncanc.cancelreturn;sfafasdfffffi" . l:default_input . "cancel_returncanc.cancelreturn.asdfas.asfdas.asdfax2123fwfe"
	"call inputsave()
	exe 'echohl PromHl'
	let l:input = input({
				\ 'prompt': ">G> ", 
				\ 'default': l:default_input,
				\ 'cancelreturn': l:cancel_return,
				\ 'highlight': 'GrepHl'
				\ })

	exe 'echohl None'
	"call inputrestore()
	"let l:input = trim(input)
	if len(l:input) == 0
		let l:input = l:default_input
	elseif l:input == l:cancel_return
		return
	endif

	if len(l:input) == 0
		return
	endif

	exe ':Leaderf rg ' . l:input
endfunction

func common_plug#config()

	"rust
	let g:cargo_makeprg_params = 'build'

	let g:onedark_color_overrides = {
				\ "black": {"gui": "#000000", "cterm": "235", "cterm16": 0}
				\ }
	colorscheme onedark
	
	let g:EasyMotion_do_mapping = 0

	"rainbow
	let g:rainbow_active = 1
	"go
	let g:go_highlight_functions = 1
	let g:go_highlight_methods = 1
	let g:go_highlight_fields = 1
	let g:go_highlight_types = 1
	let g:go_highlight_operators = 1
	let g:go_highlight_build_constraints = 1

	" vim-floaterm
	let g:floaterm_winblend = 10
	"let g:floaterm_width = &columns * 2 / 3
	"let g:floaterm_height = &lines * 3 / 4
	let g:floaterm_width = 0.7
	let g:floaterm_height = 0.8
	let g:floaterm_position = 'center'
	let g:floaterm_keymap_toggle = '<F4>'
	let g:floaterm_keymap_new    = '<leader><F4>'
	let g:floaterm_keymap_next   = '<F16>'
	let g:floaterm_border_color = "#FFFFFF"
	autocmd User Startified setlocal buflisted

	" leaderf
	let g:Lf_WindowPosition = 'popup'
    let g:Lf_PopupHeight = 0.7
	let g:Lf_PopupWidth = 0.5
	"let g:Lf_PopupPosition = [float2nr(&lines * 0.15), float2nr(&columns * 0.3)] " [ line, col ]
	"let g:Lf_PreviewInPopup = 1
	"let g:Lf_PopupPreviewPosition = 'cursor'
	let g:Lf_ShortcutF = "<leader><leader>"
	let g:Lf_ShortcutB = "<leader>b"
	nnoremap <silent><leader>t :LeaderfBufTag<CR>
	nnoremap <silent><leader>f :LeaderfFunction<CR>
	nnoremap <silent> <leader>g :call <SID>leaderf_grep_cmd()<cr><c-u>

    "let g:Lf_CtagsFuncOpts = {
    "        \ 'c': '--c-kinds=fp',
    "        \ 'rust': '--rust-kinds=nsicgtvMfP',
	"		\ 'go': '--go-kinds=ctvsia'
    "        \ }

	" Go example
    "call lsp#add_filetype_config({
    "      \ 'filetype': 'go',
    "      \ 'name': 'gopls',
    "      \ 'cmd': 'gopls'
    "      \ })

	"translator
	nnoremap <silent><leader>a :TranslateW<CR>

	"nvim-tree.lua
	let g:lua_tree_side = 'left' "left by default
	let g:lua_tree_size = 40 "30 by default
	let g:lua_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default, not working on mac atm
	let g:lua_tree_auto_open = 1 "0 by default, opens the tree when typing `vim $DIR` or `vim`
	let g:lua_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
	let g:lua_tree_follow = 0 "0 by default, this option will bind BufEnter to the LuaTreeFindFile command
	" :help LuaTreeFindFile for more info
	let g:lua_tree_show_icons = {
		\ 'git': 0,
		\ 'folders': 0,
		\ 'files': 0,
		\}
	"If 0, do not show the icons for one of 'git' 'folder' and 'files'
	"1 by default, notice that if 'files' is 1, it will only display
	"if web-devicons is installed and on your runtimepath

	" You can edit keybindings be defining this variable
	" You don't have to define all keys.
	" NOTE: the 'edit' key will wrap/unwrap a folder and open a file
	let g:lua_tree_bindings = {
		\ 'edit':        '<CR>',
		\ 'edit_vsplit': '<C-v>',
		\ 'edit_split':  '<C-x>',
		\ 'edit_tab':    '<C-t>',
		\ 'cd':          '.',
		\ 'create':      'a',
		\ 'remove':      'd',
		\ 'rename':      'r'
		\ }

	nnoremap <leader>e :LuaTreeToggle<CR>
	"nnoremap <leader>r :LuaTreeRefresh<CR>
	"nnoremap <leader>n :LuaTreeFindFile<CR>

	set termguicolors " this variable must be enabled for colors to be applied properly

	" a list of groups can be found at `:help lua_tree_highlight`
	"highlight LuaTreeFolderName guibg=cyan gui=bold,underline
	"highlight LuaTreeFolderIcon guibg=blue
endf
