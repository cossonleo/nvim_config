
local log = require('nvim-completor/log')
local manager = require("nvim-completor/src-manager")
local completor = require("nvim-completor/completor")

local queries = require'nvim-treesitter.query'
local ts_locals = require'nvim-treesitter.locals'
local parsers = require'nvim-treesitter.parsers'
local ts_utils = require'nvim-treesitter.ts_utils'
local api = vim.api

local M = {}

M.match_kinds = {
	var = 'var',
	method = 'method',
	parameter = "param",
	['function'] = 'func',
	['type'] = 'type',
}

local function is_scope_kind(kind)
	return kind == "function" or kind == "type" or kind == "method"
end

local _query = nil
local _filetype = ""
local function set_query_var()
	local cur_ft = vim.bo.filetype
	if _filetype ~=	cur_ft then
		_filetype = cur_ft
		_query = queries.get_query(_filetype, 'locals')
	end
end

local function get_smallest_context(context_type, node)
	local current_node = (node and node:parent()) or ts_utils.get_node_at_cursor()
	repeat
		if not current_node then break end
		local start_row, _, _ = current_node:start()
		for id, inode in _query:iter_captures(current_node, 0, start_row, start_row + 1) do
			if inode == current_node and _query.captures[id] == context_type then
				return current_node
			end
		end
		current_node = current_node:parent()
	until(false)
	return nil
end

local function is_node_capture_kind(node, kind)
	set_query_var()
	local start = node:start()
	for id, inode in _query:iter_captures(node, 0, start, start + 1) do
		if inode == node and _query.captures[id] == kind then
			return true
		end
	end
	return false
end

local function get_small_complete_context(node)
	local current_node = (node and node:parent()) or ts_utils.get_node_at_cursor()
	repeat
		if not current_node then break end
		local start_row, _, _ = current_node:start()
		for id, inode in _query:iter_captures(current_node, 0, start_row, start_row + 1) do
			if inode == current_node  and _query.captures[id] == "complete_scope" then
					return current_node
				end
			end
		end
		current_node = current_node:parent()
	until(false)
	return nil
end

local function find_complete_item_within_child(node)
	set_query_var()
	--local text = ts_utils.get_node_text(node, 0)[1] or "xxxxx"
	local start_row = node:start()
	--local end_row, _, _ = node:end_()
	--print("-------------" .. text .. " " ..  start_row.. " " .. end_row.. " " .. node:child_count())
	--print(vim.fn.string(_query.captures))
	if node:child_count() == 0 then return  {node} end
	for id, inode in _query:iter_captures(node, 0, start_row, start_row + 1) do
		if inode == node then
			if _query.captures[id] == "scope" then return {} end
		end

		--local mstart_row = mnode:start()
		--local text = ts_utils.get_node_text(mnode, 0)[1] or "xxxxx"
		--print(text .. " " .. (_query.captures[id] or "unknow")  .. " ".. mstart_row.. " " ..mnode:child_count())
	end

	local ret = {}
	for child in node:iter_children() do
		local items = find_complete_item_within_child(child)
		vim.list_extend(ret, items)
	end
	return ret
	--local matches = _query:iter_matches(node, 0, start_row, end_row + 1)
	--for pattern, match in matches do
	--	for id, mnode in pairs(match) do
	--		--if mnode == node then
	--			--if _query.captures[id] == "decl_var" then
	--			local text = ts_utils.get_node_text(mnode, 0)[1] or "xxxxx"
	--			print(text .. " " .. (_query.captures[id] or "unknow")  .. " ".. start_row.. " " ..mnode:child_count())
	--			--end
	--			--if node:child_count() == 0 then
	--			--	if _query.captures[id] == "definition.var" then
	--			--		return {node}
	--			--	end
	--			--elseif _query.captures[id] == "scope" then
	--			--	return {}
	--			--end
	--		--end
	--	end
	--end

	--if node:child_count() == 0 then
	--	return {}
	--end

	--print("------------------------------------------------")
	--local items = {}
	--for child in node:iter_children() do
	--	vim.tbl_extend("keep", items, find_complete_item_within_child(child))
	--end
	--return items
end

local function is_top_node(node)
	local start_row, _, _ = node:start()
	local matches = _query:iter_matches(node, 0, start_row, start_row + 1)

	for pattern, match in matches do
		for id, _ in pairs(match) do
			if _query.captures[id] == "complete_top" then
				return true
			end
		end
	end
	return false
end

local function is_def_node(node)
	--local matches = _query:iter_matches(node, 0, start_row, start_row + 1)
	local start_row, _, _ = node:start()
	for id, inode in _query:iter_captures(node, 0, start_row, start_row + 1) do
		if inode == node and _query.captures[id] == "complete_def" then
			return true
		end
	end
	return false
end

local function list_contain(list, elem)
	for _, e in ipairs(list) do
		if e == elem then return true end
	end
	return false
end

local function get_complete_nodes_in_context(line_current)
	set_query_var()
	local complete_nodes = {}
	local cur_line = line_current
	-- local current_node = ts_utils.get_node_at_cursor()
	local current_node = get_small_complete_context()
	print("start")
	repeat
		if not current_node then break end
		local start_row, _, _ = current_node:start()
		for child_node in current_node:iter_children() do
			local cstart = child_node:start()
			local cend = child_node:end_()
			if cstart > cur_line then goto continue  end
			if not is_def_node(child_node) then goto continue end
				print("----------------")
			local items = find_complete_item_within_child(child_node)
			if #items > 0 then goto continue end
			print("find ", #items)
			for id, inode in _query:iter_captures(child_node, 0, cstart, cend + 1) do
				if _query.captures[id] == "complete_item" and list_contain(items, inode) then
					-- vim.tbl_extend("keep", complete_nodes, inode)
					table.insert(complete_nodes, inode)
				end
			end
			:: continue ::
		end

		--if is_top_node(current_node) then
		--	break
		--end
		cur_line = start_row
		--current_node = current_node:parent()
		current_node = get_small_complete_context(current_node)
		--:: continue ::
		--if is_top_node(current_node) then
		--	loop_end = true
		--else
		--	current_node = current_node:parent()
		--end
		--if not current_node then loop_end = ture end
	until(true)
	return complete_nodes
end

local function get_ts_complete_items(line_current)
	local locals = ts_locals.get_locals(0)

	local completes = {}

	for _, loc in ipairs(locals) do
		if loc.complete and loc.complete.node then
			local text = ts_utils.get_node_text(loc.complete.node, 0)[1] or nil
			if text then table.insert(completes, {text = text, node = loc.complete.node}) end
		end
	end
	local nodes = get_complete_nodes_in_context(line_current)
	for _, node in ipairs(nodes) do
		local text = ts_utils.get_node_text(node, 0)[1] or nil
		if text then table.insert(completes, {text = text, node = node}) end
	end
	return completes
end


--local function get_smallest_context(source)
--	local current_node = ts_utils.get_node_at_cursor()
--	local decls = M.get_decls()
--	while current_node ~= nil and not vim.tbl_contains(decls, current_node) do
--		current_node = current_node:parent()
--	end
--	return current_node
--
--	--local scopes = ts_locals.get_locals()
--	--local current = source
--
--	--while current ~= nil and not vim.tbl_contains(scopes, current) do
--	--	current = current:parent()
--	--end
--
--	--return current or nil
--end

local function prepare_match(match, kind)
	local matches = {}

	if match.node then
		-- if kind and M.match_kinds[kind] then
			table.insert(matches, { kind = kind or "unknow", def = match.node })
		-- end
	else
		-- Recursion alert! Query matches can be nested N times deep (usually only 1 or 2).
		-- Go down until we find a node.
		for name, item in pairs(match) do
			vim.list_extend(matches, prepare_match(item, name))
		end
	end
	return matches 
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
		--local matches = prepare_match(definitions)
		--for _, match in ipairs(matches) do
		--	local node = match.def
		--	local node_scope = get_smallest_context(node)
		--	local start_line_node, _, _ = node:start()
		--	local node_text = ts_utils.get_node_text(node, bufnr)[1]
		--	local full_text = vim.trim(
		--		api.nvim_buf_get_lines(bufnr, start_line_node, start_line_node + 1, false)[1] or '')
		--	if node_text then
		--		local ok = false
		--		if is_scope_kind(match.kind) then
		--			ok = true
		--		elseif (start_line_node <= line_current) and ts_utils.is_parent(node_scope, at_point) then
		--			ok = true
		--		end
		--		if ok then
		--			ok = vim.startswith(node_text, prefix)
		--		end
		--		if ok then
		--			table.insert(complete_items, {
		--				word = node_text:sub(#prefix + 1),
		--				abbr = node_text,
		--				menu = "TS",
		--				kind = match.kind,
		--				--menu = full_text,
		--				info = full_text,
		--				score = score,
		--				icase = 1,
		--				dup = 0,
		--				empty = 1
		--			})
		--		end
		--	end
		--end
	end
	return complete_items
end

--local function get_complete_items_old(prefix, bufnr)
--	if parsers.has_parser() then
--		local at_point = ts_utils.get_node_at_cursor()
--		local _, line_current, _, _, _ = unpack(vim.fn.getcurpos())
--
--		local complete_items = {}
--		-- Support completion-nvim customized label map
--
--		-- Step 2 find correct completions
--		for _, definitions in ipairs(ts_locals.get_definitions(bufnr)) do
--			local matches = prepare_match(definitions)
--
--			for _, match in ipairs(matches) do
--				local node = match.def
--				local node_scope = get_smallest_context(node)
--				local start_line_node, _, _= node:start()
--
--				local node_text = ts_utils.get_node_text(node, bufnr)[1]
--				local full_text = vim.trim(
--					api.nvim_buf_get_lines(bufnr, start_line_node, start_line_node + 1, false)[1] or '')
--
--				if node_text 
--					and (not node_scope or ts_utils.is_parent(node_scope, at_point) or match.kind == "f") 
--					and (start_line_node <= line_current) then
--
--			if vim.startswith(node_text, prefix) then
--				table.insert(complete_items, {
--					word = node_text:sub(#prefix + 1),
--					abbr = node_text,
--					kind = match.kind,
--					menu = full_text,
--					score = score,
--					icase = 1,
--					dup = 0,
--					empty = 1
--				})
--			end
--				end
--			end
--		end
--
--		return complete_items
--	else
--		return {}
--	end
--end

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

