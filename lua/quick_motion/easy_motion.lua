
local easy_motion_ns  = vim.api.nvim_create_namespace("easy_motion_ns")
local easy_motion_buf = vim.api.nvim_create_buf(false, true)

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

local function restore_buf(buf)
	clear_hl()
	vim.api.nvim_set_current_buf(buf)
end

local function jump_char(char)
	local cur_buf = vim.api.nvim_get_current_buf()
	local top = vim.fn.line('w0')
	local bottom = vim.fn.line('w$')
	local cur_line = vim.fn.line('.')
	local lines = vim.api.nvim_buf_get_lines(0, top - 1, bottom, false)
	--print(top, bottom, #lines, vim.fn.string(lines))

	local pos_info = {}
	local nav_hl = {}
	local map_info = {}

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

	local replace_char = function(pos, char)
		local l, c = unpack(pos)
		local line = lines[l]
		line = line:sub(1, c - 1) .. char .. line:sub(c + #char)
		lines[l] = line
		table.insert(nav_hl, {l, c, c + #char})
		map_info[char] = pos
	end

	local replace_pos = function(i)
		if #pos_info < i then
			return false
		end

		char = vim.fn.nr2char(96 + i)
		replace_char(pos_info[i], char)

		if #pos_info >= 52 + i then
			local char = ';' .. char
			replace_char(pos_info[i], char)
		end

		if #pos_info >= 78 + i then
			local char = ',' .. char
			replace_char(pos_info[i], char)
		end

		if #pos_info <= 26 then
			return true
		end

		local char = vim.fn.nr2char(65 + i)
		replace_char(pos_info[26 + i], char)

		if #pos_info >= 104 + i then
			local char = ";" .. char
			replace_char(pos_info[26 + i], char)
		end

		if #pos_info >= 130 + i then
			local char = "," .. char
			replace_char(pos_info[26 + i], char)
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

	for _, hi in ipairs(nav_hl) do
		vim.api.nvim_buf_add_highlight(
			easy_motion_buf,
			easy_motion_ns,
			"Cursor",
			hi[1],
			hi[2],
			hi[3]
		)
	end

	if #pos_info > 156 then
		vim.cmd[[echoerr "find pos large than 156"]]
	end

	vim.api.nvim_set_current_buf(easy_motion_buf)
	vim.api.nvim_buf_set_lines(easy_motion_buf, 0, -1, false, lines)

	vim.schedule(function()
		local input = get_char()
		if not input then
			restore_buf(cur_buf)
			return
		end

		if input == ',' or input == ";" then
			local second = get_char()
			if not input then
				restore_buf(cur_buf)
				return
			end

			input = input .. second
		end
		
		local pos = map_info[input]
		restore_buf(cur_buf)
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
