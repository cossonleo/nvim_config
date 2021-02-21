
local M = {}

require('vim.lsp.log').set_level("error")
require('lsp_ext.server')

vim.cmd[[nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>]]
vim.cmd[[nnoremap <silent> gD :lua vim.lsp.buf.implementation()<CR>]]
vim.cmd[[nnoremap <silent> gc :lua vim.lsp.buf.rename()<CR>]]
vim.cmd[[nnoremap <silent> gk :lua vim.lsp.buf.hover()<CR>]]
vim.cmd[[nnoremap <silent> gq :lua vim.lsp.buf.formatting()<cr>]]
vim.cmd[[nnoremap <silent> ]e :lua vim.lsp.diagnostic.goto_next()<cr>]]
vim.cmd[[nnoremap <silent> [e :lua vim.lsp.diagnostic.goto_prev()<cr>]]

vim.cmd[[autocmd Filetype rust,go,c,cpp,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc]]

function M.statusline()
	if vim.fn.mode() == "n" then
		return require('lsp_ext.statusline').lsp_info()
	end
	return ""
end

return M
