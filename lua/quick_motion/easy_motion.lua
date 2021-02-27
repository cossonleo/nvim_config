
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
	local mark_map = {}

	local restore_buf = function()
		vim.api.nvim_buf_clear_namespace(0, easy_motion_ns, 0, -1)
	end

	local iter_find = function(str, c)
		local start = 1
		return function()
			local i = str:find(c, start)
			if not i then return nil end 
			start = i + 2
			return i
		end
	end

	local search_char = function(l)
		local line = lines[l]
		for i in iter_find(lines[l], char) do
			table.insert(pos_info, {l, i})
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

	collect_pos()
	if #pos_info == 0 then return end
	if #pos_info > 26 * 26 then
		vim.cmd "echoerr target pos num too large"
		return
	end

	vim.api.nvim_buf_set_extmark(0, easy_motion_ns, top - 1, 0, {
		hl_group = "Comment",
		end_line = bottom,
		end_col = 0,
	})

	local start_c = math.floor(#pos_info / 26) + 97
	local prefix = ''
	if start_c == 123 then
		prefix = 'a'
		start_c = 'a'
	end

	local cur_c = start_c 
	for i = 1, #pos_info do
		mark_map[prefix .. string.char(cur_c)] = pos_info[i]
		if cur_c == 122 then
			cur_c = start_c
			prefix = prefix == '' and 'a' or string.char(string.byte(prefix) + 1)
		else
			cur_c = cur_c + 1
		end
	end

	for virt_c, pos in pairs(mark_map) do
		local l, c = unpack(pos)
		local hl = 'EASYMOTION1'
		if #virt_c == 2 then
			hl = "EASYMOTION2"
		end

		char_marks[virt_c] = vim.api.nvim_buf_set_extmark(
			0,
			easy_motion_ns,
			top + l - 2,
			c - 1,
			{virt_text = {{virt_c, hl}}, virt_text_pos = 'overlay'}
		)
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
		until(#input > 1 or (c > prefix))
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
