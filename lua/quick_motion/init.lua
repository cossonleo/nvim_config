
for _, key in ipairs({'f', 'F', 't', 'T'}) do
	local cmd = string.format(
		":lua require'quick_motion.quick_scope'.quick_scope('%s')<cr>",
		key
	)

	vim.api.nvim_set_keymap(
		"n",
		key,
		cmd,
		{silent = true}
	)
end
