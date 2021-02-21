
function completor_handle_event(event)
	return require'completor.handle'.handle(event)
end

vim.cmd[[autocmd TextChangedP * lua completor_handle_event('TextChangedP')]]
vim.cmd[[autocmd TextChangedI * lua completor_handle_event('TextChangedI')]]
vim.cmd[[autocmd InsertEnter * lua completor_handle_event('InsertEnter')]]
vim.cmd[[autocmd InsertLeave * lua completor_handle_event('InsertLeave')]]
vim.cmd[[inoremap <m-j> <c-o>:lua completor_handle_event('JumpNextSnippet')<cr>]]
vim.cmd[[inoremap <cr> <c-r>=v:lua.completor_handle_event('CompleteDone')<cr>]]
vim.cmd[[inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "<Tab>"]]
vim.cmd[[inoremap <expr> <S-Tab>  pumvisible() ? "\<C-p>" : "\<S-Tab>"]]

vim.api.nvim_set_option('cot', "menuone,noselect,noinsert")
