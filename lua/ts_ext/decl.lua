local ts_locals = require'nvim-treesitter.locals'
local queries = require'nvim-treesitter.query'
local ts_utils = require 'nvim-treesitter.ts_utils'

local cquery = nil
local filetype = ""
local M = {}

local function reset()
	local cur_ft = vim.bo.filetype
	if filetype ~=	cur_ft then
		filetype = cur_ft
		cquery = queries.get_query(filetype, 'locals')
	end
end

function M.get_decls()
	reset()
	local locals = ts_locals.get_locals(0)

	local decls = {}

	for _, loc in ipairs(locals) do
		if loc.decl and loc.decl.node then
			table.insert(decls, loc.decl.node)
		end
	end

	return decls
end

function M.get_decl_name(current_node)
	if not cquery then return nil end
	local cur_start, _, _ = current_node:start()
	for pattern, match in cquery:iter_matches(current_node, 0, current_node:start(), current_node:end_()) do
		for id, node in pairs(match) do
			local cap = cquery.captures[id] or ""
			if cap == "decl_ident" then
				return ts_utils.get_node_text(node, 0)[1] or nil 
			end
		end
	end
	return nil
end

function M.get_decl_inents()
	reset()
	local locals = ts_locals.get_locals(0)

	local decls = {}

	for _, loc in ipairs(locals) do
		if loc.decl_ident and loc.decl_ident.node then
			table.insert(decls, loc.decl_ident.node)
		end
	end
	return decls
end

function M.get_decl_idents_with_text()
	reset()
	local locals = ts_locals.get_locals(0)

	local decls = {}

	for _, loc in ipairs(locals) do
		if loc.decl_ident and loc.decl_ident.node then
		local text = ts_utils.get_node_text(loc.decl_ident.node, 0)[1] or nil
		if text then table.insert(decls, {text = text, node = loc.decl_ident.node}) end
		end
	end
	return decls
end

function M.get_smallest_decl_context()
	local current_node = ts_utils.get_node_at_cursor()
	local decls = M.get_decls()
	while current_node ~= nil and not vim.tbl_contains(decls, current_node) do
		current_node = current_node:parent()
	end
	return current_node
end

function M.get_smallest_decl_context_text()
	local node = M.get_smallest_decl_context()
	if node then
		return M.get_decl_name(node) or ""
	end
	return ""
end

function M.test_list_decls_text()
	reset()
	local locals = ts_locals.get_locals(0)

	local decls = {}

	for _, loc in ipairs(locals) do
		if loc.decl_ident and loc.decl_ident.node then
		local text = ts_utils.get_node_text(loc.decl_ident.node, 0)[1] or nil
		if text then table.insert(decls, text) end
		end
	end
	return decls
end

return M
