local M = {}

local sym_item = {
	line = 0,
	col = 0,
	text = "",
}

function sym_item:tips()
	return string.format("%-10d", self.line)
end

function sym_item:searched_str()
	return self.text
end

function sym_item:do_item()
	return true, function()
		vim.api.nvim_win_set_cursor(0, {self.line + 1, self.col})
	end
end

function sym_item:new(line, col, text)
	local item = {line = line, col = col, text = text}
	setmetatable(item, {__index = self})
	return item
end

function M.search()
	local symbols = require'ts_ext'.get_all_context()

	local items = {}
	for _, sym in ipairs(symbols) do
		table.insert(items, sym_item:new(sym.line, sym.col, sym.text))
	end

	if vim.tbl_isempty(items) then
		return
	end

	require("easy_search.ui").new(items)
end

return M
