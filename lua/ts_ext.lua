local M = {}

local context = require "ts_ext.context"
vim.cmd[[au FileType * lua require('ts_ext.context').on_filetype()]]

function M.get_all_context()
	return context.get_all_context()
end

function M.statusline()
	return context.small_decl_context()
end

function M.get_cur_sexpr()
	local cursor = vim.api.nvim_win_get_cursor(winnr or 0)
    local parser = vim.treesitter.get_parser(0, vim.bo.filetype)
	local tstree = parser:parse()
	local root = tstree[1]:root()
	local node = root:named_descendant_for_range(cursor[1]-1,cursor[2],cursor[1]-1,cursor[2])
	print(node:sexpr())
	return node
end

return M
