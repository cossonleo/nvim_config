
--local quick_motion_status = 0
--local parsed_keys = {'f', 'F', 't', 'T'}
--vim.register_keystroke_callback(function(k)
--	if quick_motion_status == 1 then
--		require'quick_motion.quick_scope'.clear_hl()
--		quick_motion_status = 0
--	end
--	if not vim.tbl_contains(parsed_keys, k) then
--		return
--	end
--
--	if vim.api.nvim_get_mode().mode ~= "n" then return end
--	quick_motion_status = 1
--
--	vim.schedule(function()
--		require'quick_motion.quick_scope'.quick_scope(k)
--	end)
--
--end, 0)

vim.api.nvim_set_keymap(
	"n",
	"s",
	":lua require'quick_motion.easy_motion'.easy_motion()<cr>",
	{silent = true}
)

vim.cmd "hi link EASYMOTION1 Error"
vim.cmd "hi link EASYMOTION2 TODO"
