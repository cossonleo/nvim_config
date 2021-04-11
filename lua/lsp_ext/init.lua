
local M = {}

require('vim.lsp.log').set_level("error")
require('lsp_ext.server')

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover, {
		border = "single" 
	}
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
	vim.lsp.handlers.signature_help, {
		border = "single"
	}
)
   

function lsp_set_key_map()
	vim.api.nvim_buf_set_keymap(0, 'n', '<c-]>',
		':lua vim.lsp.buf.definition()<CR>',
		{silent = true}
	)
	vim.api.nvim_buf_set_keymap(0, 'n', 'gD',
		':lua vim.lsp.buf.implementation()<CR>',
		{silent = true}
	)
	vim.api.nvim_buf_set_keymap(0, 'n', 'gr',
		':lua vim.lsp.buf.rename()<CR>',
		{silent = true}
	)
	vim.api.nvim_buf_set_keymap(0, 'n', 'K',
		':lua vim.lsp.buf.hover({border = "single"})<CR>',
		{silent = true}
	)
	vim.api.nvim_buf_set_keymap(0, 'n', 'gq',
		':lua vim.lsp.buf.formatting()<CR>',
		{silent = true}
	)
	vim.api.nvim_buf_set_keymap(0, 'n', 'gf',
		':lua vim.lsp.buf.code_action()<CR>',
		{silent = true}
	)
	vim.api.nvim_buf_set_keymap(0, 'n', ']e',
		':lua vim.lsp.diagnostic.goto_next()<CR>',
		{silent = true}
	)
	vim.api.nvim_buf_set_keymap(0, 'n', '[e',
		':lua vim.lsp.diagnostic.goto_prev()<CR>',
		{silent = true}
	)
end

vim.cmd[[autocmd Filetype rust,go,c,cpp setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
vim.cmd[[autocmd Filetype rust,go,c,cpp lua lsp_set_key_map()]]

vim.cmd "hi link LspError ErrorMsg"
vim.cmd "hi link LspWarning WarningMsg"

function M.statusline()
	if vim.fn.mode() == "n" then
		return require('lsp_ext.statusline').lsp_info():sub(1,40)
	end
	return ""
end

return M
