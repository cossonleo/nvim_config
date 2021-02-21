local M = {}

vim.cmd"nnoremap <silent> [m :lua  require'ts_ext'.goto_context_start()<cr>"
vim.cmd"nnoremap <silent> ]m :lua  require'ts_ext'.goto_context_end()<cr>"
vim.cmd[[au FileType * lua require('ts_ext').on_filetype()]]

function M.list_scope_item()
	require'ts_ext.scope_items'.list_scope_item()
end

function M.open_complete()
	--require'ts_ext.complete_ref'
end

require'ts_ext.context'(M)

function M.get_cur_sexpr()
	local cursor = vim.api.nvim_win_get_cursor(winnr or 0)
    local parser = vim.treesitter.get_parser(0, vim.bo.filetype)
	local root = parser:parse():root()
	local node = root:named_descendant_for_range(cursor[1]-1,cursor[2],cursor[1]-1,cursor[2])
	print(node:sexpr())
end

return M
