local queries = require'vim.treesitter.query'
local sugar = require'share_sugar'

local buffer_ts = {}
local ft_ts = {}
local QUERY_GROUP = "context"

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
		if kind == "context_name" then temp.name = id end
		if kind == "scope" then temp.scope = id end
	end
	ft_ts[cur_ft] = temp
end

local function get_node_text(buffer, node)
	local start_row, start_col, end_row, end_col = node:range()
	local lines = sugar.get_lines(buffer, { start_row, start_col }, { end_row, end_col })
	return table.concat(lines)
end

local function get_root_node()
	local buf = sugar.buf_id()
	local parser = buffer_ts[buf].parser
	if not parser then return nil end

    local tstree = parser:parse()
	if not tstree then return nil end

	return tstree[1]:root()
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
	local count = 0
	for id, inode in bt.query:iter_captures(root, 0, pos[1], pos[1] + 1) do
		count = count + 1
		if id == cap_map.scope then
			table.insert(range_node, 1, inode)
		end
	end

	if #range_node == 0 then return "" end
	for _, inode in ipairs(range_node) do
		local start, _ = inode:start()
		for id, inode in bt.query:iter_captures(inode, 0, start, pos[1] + 1) do
			if id == cap_map.name then
				return get_node_text(buf, inode)
			end
		end
	end
	return ""
end

function _get_all_context()
	local buf = sugar.buf_id()
	local pos = sugar.get_cur_pos()

	local bt = buffer_ts[buf]
	if not bt then return "" end

	local cap_map = ft_ts[bt.ft]
	if not cap_map then return "" end

	local root = get_root_node()
	if not root then return "" end

	local root_start, _, root_end, _ = root:range()

	local context_node = {}
	local count = 0
	for id, inode in bt.query:iter_captures(root, 0, root_start, root_end + 1) do
		count = count + 1
		if id == cap_map.name then
			local inode_start, inode_col = inode:start()
			local text =  get_node_text(buf, inode)
			table.insert(context_node, {line = inode_start, col = inode_col, text = text})
		end
	end
	return context_node
end

--function _goto_smallest_decl_context(is_start)
--	if not check_and_reset_env() then return "" end
--	if not _context_cache:check_hit() then 
--		_context_cache:update_smallest_decl_context() 
--	end
--
--	if not  _context_cache.start then return end
--	local pos = is_start and _context_cache.start or _context_cache.end_
--	a.nvim_win_set_cursor(0, {pos[1] + 1, pos[2]})
--end


return function(M)
	M.on_filetype = on_filetype
	M.statusline = _get_smallest_decl_context
	M.get_all_context = _get_all_context
	--M.goto_context_start = function() _goto_smallest_decl_context(true) end
	--M.goto_context_end = function() _goto_smallest_decl_context(false) end
	--goto_pre_context = _goto_smallest_decl_context,
	--goto_next_context = _goto_smallest_decl_context,
end
