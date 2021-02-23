
local easy_motion_ns  = vim.api.nvim_create_namespace("easy_motion_ns")

local function get_char()
	local input = vim.fn.getchar()
	if input == 27 then
		return false
	end

	input = vim.fn.nr2char(input)
	return input
end


local function jump_char(char)
	local cur_buf = vim.api.nvim_get_current_buf()
	local buf_view = vim.fn.winsaveview()
	local cur_line = buf_view['lnum']
	local cur_col = buf_view['col'] -- 0=based
	local top = buf_view['topline']
	local bottom = vim.fn.line('w$')
	local lines = vim.api.nvim_buf_get_lines(0, top - 1, bottom, false)

	local pos_info = {}
	local char_marks = {}

	local restore_buf = function()
		vim.api.nvim_buf_clear_namespace(0, easy_motion_ns, 0, -1)
	end

	local search_char = function(l)
		local line = lines[l]
		local last = -1
		for i = 1, #line do
			if line:sub(i, i) == char then
				if #pos_info <= 52 or i - last > 1 then
					table.insert(pos_info, {l, i})
				end
			end
		end
	end

	local collect_pos = function()
		local cur_index = cur_line - top + 1
		local line_count = bottom - top + 1

		local loop_count = cur_index - 1
		if cur_index * 2 < line_count then
			loop_count = line_count - cur_index
		end

		for i = 1, loop_count do
			if i < cur_index then
				search_char(cur_index - i)
			end

			if i + cur_index <= line_count then
				search_char(cur_index + i)
			end
		end
	end

	local create_extmark = function(pos_i, char)
		local pos = pos_info[pos_i]
		if not pos then return end
		local l, c = unpack(pos)
		char_marks[char] = vim.api.nvim_buf_set_extmark(
			0,
			easy_motion_ns,
			top + l - 2,
			c - 1,
			{virt_text = {{char, 'Error'}}, virt_text_pos = 'overlay'}
		)
	end

	local set_buf_extmarks = function(i)
		if #pos_info < i then
			return false
		end
		
		local char = vim.fn.nr2char(96 + i)
		create_extmark(i, char)
		create_extmark(52 + i, ';' .. char)
		create_extmark(78 + i, ',' .. char)

		local char = vim.fn.nr2char(64 + i)
		create_extmark(26 + i, char)
		create_extmark(104 + i, ';' .. char)
		create_extmark(130 + i, ',' .. char)
		return true
	end
	
	collect_pos()
	if #pos_info == 0 then return end
	vim.api.nvim_buf_set_extmark(0, easy_motion_ns, top - 1, 0, {
		hl_group = "Comment",
		end_line = bottom,
		end_col = 0,
	})

	for i = 1, 26 do
		local continue = set_buf_extmarks(i)
		if not continue then break end
	end

	if #pos_info > 156 then
		vim.cmd[[echoerr "find pos large than 156"]]
	end

	local set_cursor = function(mark)
		if not mark or mark == 0 then return end
		local pos = vim.api.nvim_buf_get_extmark_by_id(0, easy_motion_ns, mark, {})
		if #pos == 0 then return end
		vim.api.nvim_win_set_cursor(0, {pos[1] + 1, pos[2]})
	end

	vim.schedule(function()
		local input = ''
		repeat
			local c = get_char()
			if not c then restore_buf(); return end
			input = input .. c
		until(#input > 1 or (c ~= "," and c ~= ";"))
		set_cursor(char_marks[input])
		restore_buf()
	end)
end

return {
	easy_motion = function()
		local char = get_char()
		if not char then return end
		jump_char(char)
	end
}
