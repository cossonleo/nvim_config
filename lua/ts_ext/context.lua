local queries = require'vim.treesitter.query'

local support_lang = {"lua", "go"}
local buffer_ts = {}

local function on_filetype()
	local cur_ft = vim.bo.filetype
	if not vim.tbl_contains(support_lang, cur_ft) then return end
	local buffer = nvim.buf_id()
    local parser = vim.treesitter.get_parser(buffer, cur_ft)
	if not parser then return end
	buffer_ts[buffer] = {parser = parser, ft = cur_ft}
end

local function get_node_text(buffer, node)
	local start_row, start_col, end_row, end_col = node:range()
	local lines = nvim.get_lines(buffer, { start_row, start_col }, { end_row, end_col })
	return table.concat(lines)
end

local function get_root_node()
	local buf = nvim.buf_id()
	local parser = parsers[buf].parser
	if not parser then return nil end

    local tstree = parser:parse()
	if not tstree then return nil end

	return tstree[1]:root()
end

local function is_inside_node(pos, node)
	local start, _, tail, _ = node:range()
	if start <=  pos[1] and pos[1] <= tail then
		return true
	end
	return false
end

function _get_smallest_decl_context()
	local buf = nvim.buf_id()
	local pos = nvim.get_cur_pos()

	local bt = buffer_ts[buf]
	if not bt then return "" end

	local root = get_root_node()
	if not root then return "" end

	-- 二分查找法搜索节点
	local cur_node = root
	local index_offset = 0
	local count = root:child_count()
	local texts = {}
	local sep_str = ""
	while(count > 0) do
		local index = index_offset
		local half = 0
		if count > 1 then
			half = math.ceil(count / 2)
			index = index + half - 1
		else
			count = 0
		end
		local select = cur_node:child(index)
		local start, _, tail, _ = select:range()
		if is_inside_node(pos, select) then
			-- start_child 为了而兼容lua
			local text, skip_childs = require('lang').context_check(select, bt.ft)
			if #text > 0 then table.insert(texts, text) end
			count = select:child_count()
			if count <= skip_childs then break end
			local next_first = select:child(skip_childs)
			local next_r, next_c, _ = next_first:start()
			if pos[1] < next_r then break end
			if pos[1] == next_r and pos[2] < next_c then break end
			cur_node = select
			index_offset = skip_childs
		else
			if pos[0] < start then 
				count = half - 1
			else
				index_offset = index_offset + half
				count = count - half
			end
		end
	end
	return table.concat(texts, " -> ")
end

local function is_need_define_kind(kind)
	if kind == "method" then return true end
	if kind == "function" then return true end
	if kind == "type" then return true end
	if kind == "macro" then return true end
	if kind == "namespace" then return true end
	if kind == "enum" then return true end
	return false
end

local function prepare_match(entry, kind)
	local entries = {}

	if entry.node then
		if not is_need_define_kind(kind) then return entries end
		entry["kind"] = kind
		table.insert(entries, entry)
	else
		for name, item in pairs(entry) do
			vim.list_extend(entries, prepare_match(item, name))
		end
	end

	return entries
end

function _get_all_context_from_telescope()
  local has_nvim_treesitter, _ = pcall(require, 'nvim-treesitter')
  if not has_nvim_treesitter then
    print('You need to install nvim-treesitter')
    return
  end

  local parsers = require('nvim-treesitter.parsers')
  if not parsers.has_parser() then
    print('No parser for the current buffer')
    return
  end

  local ts_locals = require('nvim-treesitter.locals')
  local bufnr = vim.api.nvim_get_current_buf()

  local results = {}
  for _, definitions in ipairs(ts_locals.get_definitions(bufnr)) do
    local entries = prepare_match(definitions)
    for _, entry in ipairs(entries) do
      table.insert(results, entry)
    end
  end

	local context_node = {}
	local count = 0
	for _, inode in ipairs(results) do
		local inode_start, inode_col = inode.node:start()
		local text =  get_node_text(bufnr, inode.node)
		table.insert(context_node, {line = inode_start, col = inode_col, kind = inode.kind, text = text})
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


return {
	on_filetype = on_filetype,
	statusline = _get_smallest_decl_context,
	get_all_context = _get_all_context_from_telescope,
	--M.goto_context_start = function() _goto_smallest_decl_context(true) end
	--M.goto_context_end = function() _goto_smallest_decl_context(false) end
	--goto_pre_context = _goto_smallest_decl_context,
	--goto_next_context = _goto_smallest_decl_context,
}
