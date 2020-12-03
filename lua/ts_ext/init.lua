local M = {}

function M.list_scope_item()
	require'ts_ext.scope_items'.list_scope_item()
end

function M.open_complete()
	require'ts_ext.complete_ref'
end

require'ts_ext.context'(M)

function M.get_cur_sexpr()
	local node = require'nvim-treesitter.ts_utils'.get_node_at_cursor(winnr)
	print(node:sexpr())
end

return M
