
local a = vim.api

local M = {}

-- (row, col) -- 0-based
function M.get_cur_pos(buf)
	local b = buf or 0
	local pos = a.nvim_win_get_cursor(b)
	return {pos[1] - 1, pos[2]}
end

function M.buf_id()
	return a.nvim_get_current_buf()
end

-- [start(row, col), end(row, col))
-- 0-based index
function M.get_lines(buf, start, end_)
	local lines = vim.api.nvim_buf_get_lines(buf, start[1], end_[1] + 1, false)
	if #lines == 0 then return lines end
	lines[1] = lines[1]:sub(start[2] + 1)
	if #lines < end_[1] - start[1] + 1 then return lines end
	if end_[2] == 0 then
		table.remove(lines)
		return lines
	end
	lines[#lines] = lines[#lines]:sub(1, end_[2])
	return lines
end

return M
