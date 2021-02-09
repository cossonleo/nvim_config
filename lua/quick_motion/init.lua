local quick_motion_ns = vim.api.nvim_create_namespace("quick_motion_ns")
-- nvim_buf_clear_namespace()

local quick_row = -1
local quick_col = -1

local function get_next_chars_index(reversal)
	local lines = vim.api.nvim_buf_get_lines(0, quick_row, quick_row + 1, false)
	if #lines == 0 then return end
	local line = lines[1]
	local col = quick_col + 1
	if col >= #line then return end
	local checked = {}
	local nexts = {}
	for i = col + 1, #line do
		local char = line:sub(i, i)
		if not checked[char] then 
			table.insert(nexts, i - 1)
			checked[char] = true
		end
	end

	return nexts
end

local function add_highlight_to_nexts(nexts)
	vim.api.nvim_buf_add_highlight(0, quick_motion_ns, "Normal", quick_row, 0, 100)
	local col_start, col_end = -1, -1
	local add_hl = function(i)
		if col_start == -1 then
			col_start = i
			col_end = i
			return
		end

		if i - col_end == 1 then
			col_end = i
			return
		end
		vim.api.nvim_buf_add_highlight(0, quick_motion_ns, "Function", quick_row, col_start, col_end)
		col_start = -1
		col_end = -1
	end

	for _, i in ipairs(nexts) do
		add_hl(i)
	end

	if col_start ~= -1 then
		vim.api.nvim_buf_add_highlight(0, quick_motion_ns, "Function", quick_row, col_start, col_end)
	end
end

function quick_scope_add_hl()
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	quick_row = row -1
	quick_col = col
	local nexts = get_next_chars_index()
	if not nexts then
		quick_row = -1
		quick_col = -1
	end
	add_highlight_to_nexts(nexts)
end

function quick_scope_clear_hl()
	if quick_row == -1 then return end
	vim.api.nvim_buf_clear_namespace(0, quick_motion_ns, quick_row, quick_row + 1)
	quick_row = -1
	quick_col = -1
end
