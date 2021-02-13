
local easy_motion_ns  = vim.api.nvim_create_namespace("easy_motion_ns")
local easy_motion_buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_option(easy_motion_buf, "buftype", "nofile")
vim.api.nvim_buf_set_option(easy_motion_buf, "swapfile", false)

local function clear_hl()
	vim.api.nvim_buf_clear_namespace(easy_motion_buf, easy_motion_ns, 0, -1)
end

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
	local nav_hl = {}
	local map_info = {}

	local restore_buf = function()
		clear_hl()
		vim.api.nvim_set_current_buf(cur_buf)
		vim.fn.winrestview(buf_view)
	end

	local find_char = function(l)
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

	local find_pos = function()
		local cur_index = cur_line - top + 1
		local line_count = bottom - top + 1

		local loop_count = cur_index - 1
		if cur_index * 2 < line_count then
			loop_count = line_count - cur_index
		end

		for i = 1, loop_count do
			if i < cur_index then
				find_char(cur_index - i)
			end

			if i + cur_index <= line_count then
				find_char(cur_index + i)
			end
		end
	end

	local apply_char = function(pos_i, char)
		local pos = pos_info[pos_i]
		if not pos then return end

		local l, c = unpack(pos)
		local line = lines[l]
		line = line:sub(1, c - 1) .. char .. line:sub(c + #char)
		lines[l] = line
		table.insert(nav_hl, {l - 1, c - 1, c + #char - 1})
		map_info[char] = pos
	end

	local replace_pos = function(i)
		if #pos_info < i then
			return false
		end
		
		local char = vim.fn.nr2char(96 + i)
		apply_char(i, char)
		apply_char(52 + i, ';' .. char)
		apply_char(78 + i, ',' .. char)

		local char = vim.fn.nr2char(64 + i)
		apply_char(26 + i, char)
		apply_char(104 + i, ';' .. char)
		apply_char(130 + i, ',' .. char)
		return true
	end
	
	local set_easy_motion_buf = function()
		vim.api.nvim_set_current_buf(easy_motion_buf)
		vim.api.nvim_buf_set_lines(easy_motion_buf, 0, -1, false, lines)
		vim.api.nvim_win_set_cursor(0, {cur_line - top + 1, cur_col})

		for _, hi in ipairs(nav_hl) do
			vim.api.nvim_buf_add_highlight(
				easy_motion_buf,
				easy_motion_ns,
				"Error",
				hi[1],
				hi[2],
				hi[3]
			)
		end
	end

	find_pos()
	if #pos_info == 0 then
		return
	end

	for i = 1, 26 do
		if not replace_pos(i) then
			break
		end
	end

	if #pos_info > 156 then
		vim.cmd[[echoerr "find pos large than 156"]]
	end

	set_easy_motion_buf()

	vim.schedule(function()
		local input = get_char()
		if not input then
			restore_buf()
			return
		end

		if input == ',' or input == ";" then
			local second = get_char()
			if not input then
				restore_buf()
				return
			end

			input = input .. second
		end
		
		local pos = map_info[input]
		restore_buf()
		if not pos then return end

		local real_pos = {pos[1] + top - 1, pos[2] - 1}
		vim.api.nvim_win_set_cursor(0, real_pos)
	end)
end

return {
	easy_motion = function()
		local char = get_char()
		if not char then return end
		jump_char(char)
	end
}
