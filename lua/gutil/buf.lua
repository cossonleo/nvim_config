
local a = vim.api

-- (row, col) -- 0-based
nvim.get_cur_pos = function(buf)
	local b = buf or 0
	local pos = a.nvim_win_get_cursor(b)
	return {pos[1] - 1, pos[2]}
end

nvim.buf_id = function()
	return a.nvim_get_current_buf()
end

-- [start(row, col), end(row, col))
-- 0-based index
nvim.get_lines = function(buf, start, end_)
	local lines = vim.api.nvim_buf_get_lines(buf, start[1], end_[1] + 1, false)
	if #lines == 0 then return lines end
	if #lines == end_[1] - start[1] + 1 then
		lines[#lines] = lines[#lines]:sub(1, end_[2])
	end
	if #lines[#lines] == 0 then
		table.remove(lines)
		return lines
	end
	lines[1] = lines[1]:sub(start[2] + 1)
	return lines
end
