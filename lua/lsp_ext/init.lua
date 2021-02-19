
local M = {}

require('vim.lsp.log').set_level(4)
require('lsp_ext.server')

function M.statusline()
	if vim.fn.mode() == "n" then
		return require('lsp_ext.statusline').lsp_info()
	end
	return ""
end

return M
