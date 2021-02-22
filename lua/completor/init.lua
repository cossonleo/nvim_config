
function completor_handle_event(event)
	return require'completor.handle'.handle(event)
end

local function autocmd(event)
	local cmd = string.format(
		"autocmd %s * lua completor_handle_event('%s')",
		event,
		event
	)

	vim.cmd(cmd)
end

autocmd("TextChangedP")
autocmd("TextChangedI")
autocmd("InsertEnter")
--autocmd("InsertLeave")

vim.cmd[[inoremap <m-j> <c-o>:lua completor_handle_event('JumpNextSnippet')<cr>]]
vim.cmd[[inoremap <cr> <c-r>=v:lua.completor_handle_event('CompleteDone')<cr>]]
vim.cmd[[inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "<Tab>"]]
vim.cmd[[inoremap <expr> <S-Tab>  pumvisible() ? "\<C-p>" : "\<S-Tab>"]]

vim.api.nvim_set_option('cot', "menuone,noselect,noinsert")
