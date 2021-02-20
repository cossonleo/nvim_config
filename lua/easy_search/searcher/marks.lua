local M = {}

local mark_item = {
	file = "",
	line = "",
	col = "",
	content = "",
}

function mark_item:tips()
	return "[" .. self.file .. ":" .. self.line .. "]"
end

function mark_item:searched_str()
	return self.content
end

function mark_item:do_item()
	return true, function()
		vim.cmd(":edit " .. self.file)
		local win_id = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_cursor(win_id, {self.line + 1, self.col})
	end
end

function mark_item:new(file, line, col, content)
	local item = {file = file, line = line, col = col, content = content}
	setmetatable(item, {__index = self})
	return item
end

function M.search()
end

return M
