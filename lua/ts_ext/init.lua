
local M = {}

function M.list_scope_item()
	require'ts_ext.scope_items'.list_scope_item()
end

function M.stl()
	return require'ts_ext.context'.statusline()
end

function M.open_complete()
	require'ts_ext.complete_ref'
end

return M
