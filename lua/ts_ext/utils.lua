local queries = require'nvim-treesitter.query'
local ts_utils = require 'nvim-treesitter.ts_utils'
--local pcall(require, 'nvim-treesitter')


local cquery = nil
local filetype = ""
local M = {}

local function reset()
	local cur_ft = vim.bo.filetype
	if filetype ~=  cur_ft then
		filetype = cur_ft
		cquery = queries.get_query(filetype, 'locals')
	end
end

local check_match = function(name)
	if not name then
		return nil
	end
	if name == "definition.function" then
		return "F"
	end
	if name == "definition.method" then
		return "F"
	end
	if name == "definition.type" then
		return "T"
	end
	if name == "definition.macro" then
		return "M"
	end
	--if name == "definition.namespace" then
	--	return "N"
	--end
	return nil
end

function M.get_smallest_context(node)
	local has, ts_locals = pcall(require, 'nvim-treesitter.locals')
	if not has then return nil end

	local scopes = ts_locals.get_scopes()
	local current = node

	while current ~= nil and not vim.tbl_contains(scopes, current) do
		current = current:parent()
	end

	return current or nil
end

function M.get_context_def_text(current_node)
	reset()
	if not cquery then return nil end
	local cur_start, _, _ = current_node:start()
	for pattern, match in cquery:iter_matches(current_node, 0, current_node:start(), current_node:end_()) do
		for id, node in pairs(match) do
			local node_start, _, _ = node:start()
			if node_start > cur_start then
				return nil
			end

			return ts_utils.get_node_text(node, 0)[1] or nil
			--local t = check_match(cquery.captures[id]) -- name of the capture in the query
			--if t then
			--	local text = ts_utils.get_node_text(node, 0)[1] or ""
			--	return text
			--end
		end
	end
	return nil
end

function M.stl()
	reset()
	if not cquery then return "" end


	-- local search = function()
	-- 	local cur_start, _, _ = current_node:start()
	-- 	for pattern, match in cquery:iter_matches(current_node, 0, current_node:start(), current_node:end_()) do
	-- 		for id, node in pairs(match) do
	-- 			local node_start, _, _ = node:start()
	-- 			if node_start > cur_start then
	-- 				return nil
	-- 			end

	-- 			local t = check_match(cquery.captures[id]) -- name of the capture in the query
	-- 			if t then
	-- 				local text = ts_utils.get_node_text(node, 0)[1] or ""
	-- 				--return t .. ":" .. text
	-- 				return text
	-- 			end
	-- 		end
	-- 	end
	-- 	return nil
	-- end

	local current_node = ts_utils.get_node_at_cursor()
	local context = M.get_smallest_context(current_node)
	if not context then return "" end
	return M.get_context_def_text(context) or ""

--	repeat 
--		if current_node then
--			current_node = current_node:parent()
--		else
--			current_node = ts_utils.get_node_at_cursor()
--		end
--		if not current_node then return "" end
--		local ret = search()
--		if ret then
--			return ret
--		end
--	until(false)
end

return M
