
local M = {}

function M.list_scope_item()
	require'ts_ext.scope_items'.list_scope_item()
end

function M.stl()
	return require'ts_ext.decl'.get_smallest_decl_context_text()
end

function M.open_complete()
	require'ts_ext.complete_ref'
end

return M
