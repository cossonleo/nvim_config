
vim.api.nvim_exec([[
autocmd User PlugAddEvent Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
autocmd User PlugAddEvent Plug 'kyazdani42/nvim-tree.lua'
autocmd User PlugEndEvent lua require'navplug'.config()
autocmd UIEnter * lua vim.g.lua_tree_auto_open = 1
]], nil)

M = {}
M.config = function()
	vim.g.Lf_WindowPosition = 'popup'
	vim.g.Lf_PopupHeight = 0.7
	vim.g.Lf_PopupWidth = 0.5
	vim.g.Lf_ShortcutF = "<leader><leader>"
	vim.g.Lf_ShortcutB = "<leader>b"
	vim.api.nvim_set_keymap("n", "<leader>t", ":LeaderfBufTag<CR>", {noremap = true, silent = true})
	vim.api.nvim_set_keymap("n", "<leader>f", ":LeaderfFunction<CR>", {noremap = true, silent = true})

	vim.g.lua_tree_side = 'left' -- left by default
	vim.g.lua_tree_size = 40 --30 by default
	vim.g.lua_tree_ignore = { '.git', 'node_modules', '.cache' } --empty by default, not working on mac atm
	vim.g.lua_tree_auto_close = 1 --0 by default, closes the tree when it's the last window
	vim.g.lua_tree_follow = 0 --0 by default, this option will bind BufEnter to the LuaTreeFindFile command
	-- :help LuaTreeFindFile for more info
	vim.g.lua_tree_show_icons = {git = 0, folders = 0, files = 0 }

	vim.g.lua_tree_bindings = {
		edit = '<CR>',
		edit_vsplit = '<C-v>',
		edit_split = '<C-x>',
		edit_tab = '<C-t>',
		cd = '.',
		create = 'a',
		remove = 'd',
		rename = 'r',
	}
	vim.api.nvim_set_keymap("n", "<leader>e", ":LuaTreeToggle<CR>", {noremap = true, silent = true})
end
return M
