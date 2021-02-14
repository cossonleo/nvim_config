local log = require('completor/log')
local manager = require("completor/src-manager")
local completor = require("completor/completor")

local queries = require'nvim-treesitter.query'
local ts_locals = require'nvim-treesitter.locals'
local parsers = require'nvim-treesitter.parsers'
local ts_utils = require'nvim-treesitter.ts_utils'
local api = vim.api

local M = {}

local QUERY_GROUP = "complete"
local FUNC_KIND_ID = 0
local ITEM_KIND_ID = 0
local TOP_KIND_ID = 0
local SCOPE_KIND_ID = 0
local DEF_KIND_ID = 0

local init_kind_id = {
	["func"] = function(id) FUNC_KIND_ID = id end
	["item"] = function(id) ITEM_KIND_ID = id end
	["top"] = function(id) TOP_KIND_ID = id end
	["scope"] = function(id) SCOPE_KIND_ID = id end
	["def"] = function(id) DEF_KIND_ID = id end
}

local _query = nil
local _filetype = ""
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

local capture_cache = {}

local function node_capture_kind(cur_node, kinds, parent)
	local node = parent or cur_node
	local start = cur_node:start()

	local is_contain = function(kind)
		for _, k in ipairs(kinds) do
			if k == kind then return true end
		end
		return false
	end

	local match_kind = nil
	for id, inode in _query:iter_captures(node, 0, start, start + 1) do
		capture_cache[inode] = capture_cache[inode] or {}
		table.insert(capture_cache[inode], id)
		if inode == cur_node then
			if is_contain(kind) then
				match_kind = match_kind or {}
				table.insert(match_kind, kind)
			end
		end
	end
	
	return match_kind
end

local function get_small_complete_context(node)
	local current_node = (node and node:parent()) or ts_utils.get_node_at_cursor()
	while current_node do
		if node_capture_kind(current_node, {SCOPE_KIND}) then
			return current_node
		end
		current_node = current_node:parent()
	end
	return nil
end

local function find_complete_item_within_child(node, parent)
	local start_row = node:start()
	local end_row = node:end_()
	local ret = {}
	if node:child_count() == 0 then 
		if node_capture_kind(node, {ITEM_KIND}, parent) then
			ret[node] = ITEM_KIND
		end
		return ret
	end

	for child in node:iter_children() do
		if not node_capture_kind(child, {SCOPE_KIND}) then 
			local items = find_complete_item_within_child(child, parent or node)
			vim.tbl_extend('keep', ret, items)
		end
	end
	return ret
end

local function list_contain(list, elem)
	for _, e in ipairs(list) do
		if e == elem then return true end
	end
	return false
end

local function get_func_name_node(node)
	if node:child_count() == 0 then return "" end
	local not_leafs = {}
	for child in node:iter_children() do
		if child:child_count() == 0 and 
			is_node_capture_kind(child, "func_name", node) 
		then
			return child
		end
	end
	return nil
end

local function get_complete_nodes_in_context(line_current)
	set_query_var()
	local complete_nodes = {}
	local cur_line = line_current
	-- local current_node = ts_utils.get_node_at_cursor()
	local current_node = get_small_complete_context()
	print("start")
	while (current_node) do
		local start_row, _, _ = current_node:start()
		for child_node in current_node:iter_children() do
			local cstart = child_node:start()
			local cend = child_node:end_()
			if node_capture_kind(child_node, {FUNC_KIND}) then
				local name_node = get_func_name_node(child_node) 
				if name_node then complete_nodes[name_node] = "func" end
				goto continue
			end
			if cstart > cur_line then goto continue  end
			if not node_capture_kind(child_node, {DEF_KIND}) then goto continue end
			local items = find_complete_item_within_child(child_node)
			vim.tbl_extend('keep', complete_nodes, items)
			:: continue ::
		end

		if node_capture_kind(child_node, {TOP_KIND} then break end
		cur_line = start_row
		current_node = get_small_complete_context(current_node)
	end
	return complete_nodes
end

local function get_ts_complete_items(line_current)
	local locals = ts_locals.get_locals(0)

	local completes = {}

	local nodes = get_complete_nodes_in_context(line_current)
	for _, node in ipairs(nodes) do
		local text = ts_utils.get_node_text(node, 0)[1] or nil
		if text then table.insert(completes, {text = text, node = node}) end
	end
	return completes
end

local function get_complete_items(bufnr, line_current, prefix)
	if not parsers.has_parser() then return {} end
	local complete_items = {}

	local nodes = get_ts_complete_items(line_current)

	--local ts_decl = require'ts_ext.decl'

	--local at_point = ts_utils.get_node_at_cursor()
	--local decls = ts_decl.get_decl_idents_with_text()
	for _, node in ipairs(nodes) do
		local node_text = node.text
		local node = node.node
		local start_line, _, _ = node:start()
		if vim.startswith(node_text, prefix) then
			table.insert(complete_items, {
				word = node_text:sub(#prefix + 1),
				abbr = node_text,
				menu = "TS",
				--kind = node.kind,
				--menu = full_text,
				info = full_text,
				score = score,
				icase = 1,
				dup = 0,
				empty = 1
			})
		end
	end
	return complete_items
end

local function request(ctx)
	local prefix = ctx:typed_to_cursor():match('[%w_]+$') or ""
	local items = get_complete_items(ctx.buf, ctx.pos[1], prefix) 
	completor.add_complete_items(ctx, items)
end

--manager:add_src("ts_complete", request)
log.info("add treesitter complete source finish")

return {
	comp = function() 
		local items = get_complete_nodes_in_context(1000)
		for _, item in ipairs(items) do
			local text = ts_utils.get_node_text(item, 0)[1] or "xxxxx"
			print("complete items", text)
		end
	end, 
	find = find_complete_item_within_child
}
