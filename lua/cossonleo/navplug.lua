local M = {}

-- M["'Yggdroot/LeaderF', { 'do': './install.sh' }"] = function()
-- 	vim.g.Lf_WindowPosition = 'popup'
-- 	vim.g.Lf_PopupHeight = 0.8
-- 	vim.g.Lf_PopupWidth = 0.5
-- 	vim.g.Lf_ShortcutF = "<leader><leader>"
-- 	vim.g.Lf_ShortcutB = "<leader>b"
-- 	vim.api.nvim_set_keymap("n", "<leader>t", ":LeaderfBufTag<CR>", {noremap = true, silent = true})
-- 	vim.api.nvim_set_keymap("n", "<leader>f", ":LeaderfFunction<CR>", {noremap = true, silent = true})
-- 	vim.api.nvim_set_keymap("n", "<leader>c", ":LeaderfQuickFix<CR>", {noremap = true, silent = true})
-- end

M["'kyazdani42/nvim-tree.lua'"] = function()
	vim.g.lua_tree_side = 'left' -- left by default
	vim.g.lua_tree_size = 40 --30 by default
	vim.g.lua_tree_ignore = { '.git', 'node_modules', '.cache' } --empty by default, not working on mac atm
	vim.g.lua_tree_auto_close = 1 --0 by default, closes the tree when it's the last window
	vim.g.lua_tree_follow = 0 --0 by default, this option will bind BufEnter to the LuaTreeFindFile command
	-- :help LuaTreeFindFile for more info
	vim.g.lua_tree_show_icons = {git = 1, folders = 1, files = 1 }
	vim.g.lua_tree_tab_open = 1

	vim.g.lua_tree_bindings = {
		edit = '<CR>', edit_vsplit = '<C-v>', edit_split = '<C-x>', edit_tab = '<C-t>',
		toggle_ignored = 'I', toggle_dotfiles = 'H', preview = '<Tab>', cd = '.',
		create = 'a', remove = 'd', rename = 'r', refresh = 'R',
		cut = 'x', copy = 'c', paste = 'p',
		-- prev_git_item = '[c', next_git_item = ']c',
	}
	vim.api.nvim_set_keymap("n", "<leader>e", ":LuaTreeToggle<CR>", {noremap = true, silent = true})
end

-- nerd-fonts
M["'kyazdani42/nvim-web-devicons'"] = function()
end
--M["'cossonleo/easyfind.nvim'"] = function()
--end
M["'nvim-lua/popup.nvim'"]  = function() end
M["'nvim-lua/plenary.nvim'"] = function() end
M["'nvim-lua/telescope.nvim'"] = function() 
 	vim.api.nvim_set_keymap("n", "<leader>g", ":lua require'telescope.builtin'.grep_string{}<cr>", {noremap = true, silent = true})
 	vim.api.nvim_set_keymap("n", "<leader>b", ":lua require'telescope.builtin'.buffers{}<CR>", {noremap = true, silent = true})
 	vim.api.nvim_set_keymap("n", "<leader><leader>", ":lua require'telescope.builtin'.find_files{}<CR>", {noremap = true, silent = true})
end

return M
