
function completor_handle_event(event)
	return require'completor.handle'.handle(event)
end

vim.cmd[[autocmd TextChangedP * lua completor_handle_event('TextChangedP')]]
vim.cmd[[autocmd TextChangedI * lua completor_handle_event('TextChangedI')]]
vim.cmd[[autocmd InsertEnter * lua completor_handle_event('InsertEnter')]]
vim.cmd[[autocmd InsertLeave * lua completor_handle_event('InsertLeave')]]
vim.cmd[[inoremap <m-j> <c-o>:lua completor_handle_event('JumpNextSnippet')]]
vim.cmd[[inoremap <cr> <c-r>=v:lua.completor_handle_event('CompleteDone')<cr>]]

vim.api.nvim_set_option('cot', "menuone,noselect,noinsert")

vim.api.nvim_register_filterfunc(function(prefix, match)
	if #prefix == 0 then
		return 1
	end
	local filter = prefix:match("[%w_]+")
	if not filter or #filter == 0 then return 1 end

	local str = ""
	local t = type(match)
	if t == "string" then
		str = match 
	elseif t == "table" then
		str = match.abbr
	end
	
	return require'completor.fuzzy_match'.fuzzy_match(filter, str)
end)
