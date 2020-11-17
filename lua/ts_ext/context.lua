local queries = require'vim.treesitter.query'
local sugar = require'share_sugar'
--local ts_locals = require'nvim-treesitter.locals'
--local parsers = require'nvim-treesitter.parsers'
--local ts_utils = require'nvim-treesitter.ts_utils'

local buffer_ts = {}
local ft_ts = {}
local QUERY_GROUP = "complete"

local function on_filetype()
	local cur_ft = vim.bo.filetype

	local query = queries.get_query(cur_ft, QUERY_GROUP)
	if query == nil then return end

    local parser = vim.treesitter.get_parser(0, cur_ft)
	if not parser then return end

	local buffer = sugar.buf_id()
	buffer_ts[buffer] = {parser = parser, query = query, ft = cur_ft}

	local temp = ft_ts[cur_ft]
	if temp then return end
	temp = {}
	for id, kind in ipairs(query.captures) do
		if kind == "func" then temp.func = id end
		if kind == "type" then temp.type = id end
		if kind == "name" then temp.name = id end
	end
	ft_ts[cur_ft] = temp
end

local function get_node_text(buffer, node)
	local start_row, start_col, end_row, end_col = node:range()
	return sugar.get_lines(buffer, { start_row, start_col }, { end_row, end_col - 1 })
end

local function get_root_node()
	local buf = sugar.buf_id()
	local parser = buffer_ts[buf].parser
	if not parser then return nil end

    local tstree = parser:parse()
	if not tstree then return nil end

	return tstree:root()
end

function _get_smallest_decl_context()
	local buf = sugar.buf_id()
	local pos = sugar.get_cur_pos()

	local bt = buffer_ts[buf]
	if not bt then return "" end

	local cap_map = ft_ts[bt.ft]
	if not cap_map then return "" end

	local root = get_root_node()
	if not root then return "" end

	local range_node = {}
	for id, inode in bt.query:iter_captures(root, 0, pos[1], pos[1] + 1) do
		if id == cap_map.func or id == cap_map.type then
			table.insert(range_node, 1, inode)
		end
	end

	if #range_node == 0 then return "" end

	for _, inode in ipairs(range_node) do
		local start, _ = inode:start()
		for id, inode in bt.query:iter_captures(root, 0, start, pos[1] + 1) do
			if id == cap_map.name then
				local lines = get_node_text(buf, inode)
				return table.concat(lines)
			end
		end
	end
	return ""
end

function _goto_smallest_decl_context(is_start)
	if not check_and_reset_env() then return "" end
	if not _context_cache:check_hit() then 
		_context_cache:update_smallest_decl_context() 
	end

	if not  _context_cache.start then return end
	local pos = is_start and _context_cache.start or _context_cache.end_
	a.nvim_win_set_cursor(0, {pos[1] + 1, pos[2]})
end

return function(M)
	M.on_filetype = on_filetype
	M.statusline = _get_smallest_decl_context
	M.goto_context_start = function() _goto_smallest_decl_context(true) end
	M.goto_context_end = function() _goto_smallest_decl_context(false) end
	--goto_pre_context = _goto_smallest_decl_context,
	--goto_next_context = _goto_smallest_decl_context,
end
