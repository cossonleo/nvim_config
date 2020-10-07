local log = require('nvim-completor/log')
local manager = require("nvim-completor/src-manager")
local completor = require("nvim-completor/completor")

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

local cquery = nil
local filetype = ""
local function set_query_var()
	local cur_ft = vim.bo.filetype
	if filetype ~=	cur_ft then
		filetype = cur_ft
		cquery = queries.get_query(filetype, 'locals')
	end
end

local function get_ts_complete_items()
	--set_query_var()
	local locals = ts_locals.get_locals(0)

	local completes = {}

	for _, loc in ipairs(locals) do
		if loc.complete then
			table.insert(completes, loc.complete)
			local text = ts_utils.get_node_text(loc.complete, 0)[1] or nil
			if text then table.insert(completes, {text = text, node = loc.complete})
		end
	end

	return completes
end

local function get_smallest_context(source)
	local current_node = ts_utils.get_node_at_cursor()
	local decls = M.get_decls()
	while current_node ~= nil and not vim.tbl_contains(decls, current_node) do
		current_node = current_node:parent()
	end
	return current_node

	local scopes = ts_locals.get_locals()
	local current = source

	while current ~= nil and not vim.tbl_contains(scopes, current) do
		current = current:parent()
	end

	return current or nil
end

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

	local ts_decl = require'ts_ext.decl'

	local at_point = ts_utils.get_node_at_cursor()
	local decls = ts_decl.get_decl_idents_with_text()
	for _, decl in ipairs(decls) do
		local node_text = decl.text
		local node = decl.node
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

manager:add_src("ts_complete", request)
log.info("add treesitter complete source finish")
