
if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

autocmd User PlugAddEvent call <SID>add()
autocmd User PlugEndEvent call <SID>config()

func s:add()
		Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
		Plug 'kyazdani42/nvim-tree.lua'
"	Plug 'kyazdani42/nvim-web-devicons' " for file icons
endfunc

func s:config()
	" leaderf
	let g:Lf_WindowPosition = 'popup'
    let g:Lf_PopupHeight = 0.7
	let g:Lf_PopupWidth = 0.5
	let g:Lf_ShortcutF = "<leader><leader>"
	let g:Lf_ShortcutB = "<leader>b"
	nnoremap <silent><leader>t :LeaderfBufTag<CR>
	nnoremap <silent><leader>f :LeaderfFunction<CR>
	"nnoremap <silent><leader>g :lua my_init_lua.grep_dir()<cr>

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

	"let s:one_colors = onedark#GetColors()
	highlight LuaTreeFolderIcon guifg=#61AFEF
endfunc
