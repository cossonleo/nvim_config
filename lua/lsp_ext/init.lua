
local M = {}

nvim.lsp = nvim.lsp or {}

require('vim.lsp.log').set_level("error")

require('lsp_ext.server')

vim.cmd "hi link LspError ErrorMsg"
vim.cmd "hi link LspWarning WarningMsg"

function M.statusline()
	if vim.fn.mode() == "n" then
		return require('lsp_ext.statusline').lsp_info():sub(1,40)
	end
	return ""
end

return M
