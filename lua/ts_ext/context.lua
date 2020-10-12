local queries = require'nvim-treesitter.query'
local ts_locals = require'nvim-treesitter.locals'
local parsers = require'nvim-treesitter.parsers'
local ts_utils = require'nvim-treesitter.ts_utils'
local api = vim.api

local M = {}

local QUERY_GROUP = "complete"
local SCOPE_KIND_ID = 0
local FUNC_KIND_ID = 0
local FUNC_NAME_ID = 0
local METHOD_KIND_ID = 0
local METHOD_NAME_ID = 0
local TYPE_KIND_ID = 0
local TYPE_NAME_ID = 0
local init_kind_id = {
	["scope"] = function(id) SCOPE_KIND_ID = id end,
	["func"] = function(id) FUNC_KIND_ID = id end,
	["method"] = function(id) METHOD_KIND_ID = id end,
	["type"] = function(id) TYPE_KIND_ID = id end,
	["name.func"] = function(id) FUNC_NAME_ID = id end,
	["name.method"] = function(id) METHOD_NAME_ID = id end,
	["name.type"] = function(id) TYPE_NAME_ID = id end,
}

local _query = nil
local _filetype = ""
local _capture_cache = {}
local _cur_stl_node = nil
local function set_query_var()
	local cur_ft = vim.bo.filetype
	if _filetype ~=	cur_ft then
		_filetype = cur_ft
		_query = queries.get_query(_filetype, QUERY_GROUP)
		for id, kind in ipairs(_query.captures) do
			local init = init_kind_id[kind]
			if init then init(id) end
		end
	end
end

local function reset()
	set_query_var()
	_capture_cache = {}
end

local function node_id(node)
	return string.format("%s_%d_%d_%d_%d", node:symbol(), node:range())
end

local function get_node_capture_kind(cur_node, parent)
	local cur_id = node_id(cur_node)
	local cache = _capture_cache[cur_id] or nil
	if cache then return cache end

	local node = parent or cur_node
	local start = cur_node:start()


	for id, inode in _query:iter_captures(node, 0, start, start + 1) do
		local inode_id = node_id(inode)
		_capture_cache[inode_id] = _capture_cache[inode_id] or {}
		table.insert(_capture_cache[inode_id], id)
	end

	return _capture_cache[cur_id] or nil
end

local function is_node_kind(node, kind, parent)
	local kinds = get_node_capture_kind(node, parent)
	if not kinds then return false end
	for _, k in ipairs(kinds) do
		if k == kind then return true end
	end
	return false
end

local function get_smallest_decl_context(node)
	local current_node = (node and node:parent()) or ts_utils.get_node_at_cursor()
	while current_node do
		if is_node_kind(current_node, FUNC_KIND_ID) or 
			is_node_kind(current_node, METHOD_KIND_ID) or
			is_node_kind(current_node, TYPE_KIND_ID)
		then 
			return current_node 
		end
		current_node = current_node:parent()
	end
	return nil
end

local function get_decl_name_node(node, parent)
	if not node or node:child_count() == 0 then return "" end
	local parent = parent or node
	local not_leafs = {}
	for child in node:iter_children() do
		if child:child_count() == 0 then
			if is_node_kind(child, FUNC_NAME_ID, parent) or 
				is_node_kind(child, METHOD_NAME_ID, parent) or
				is_node_kind(child, TYPE_NAME_ID, parent)
			then
				return child
			end
		elseif not is_node_kind(child, SCOPE_KIND_ID, parent) then
			table.insert(not_leafs, child)
		end
	end

	for _, lnode in ipairs(not_leafs) do
		local ln = get_decl_name_node(lnode, parent)
		if ln then return ln end
	end

	return nil
end

local function is_cur_node()
	local pos = vim.fn.getpos('.')
	local cl, ce = pos[2] - 1, pos[3] - 1
	local sl, sc, el, ec = _cur_stl_node:range()
	if sl > cl then return false end
	if sl == cl and sc > ce then return false end
	if cl > el then return false end
	if cl == el and ce > ec then return false end
	return true
end

function M.statusline()
	--if _cur_stl_node and is_cur_node() then
	--	return get_decl_name(_cur_stl_node) or ""
	--end

	reset()
	--_cur_stl_node = get_smallest_decl_context()
	local node = get_smallest_decl_context()
	if not node then return "" end
	local name_node = get_decl_name_node(node)
	if not name_node then return "" end
	return ts_utils.get_node_text(name_node, 0)[1] or ""
end

return M
