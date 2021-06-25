local M = {}

local sym_item = {
	line = 0,
	col = 0,
	text = "",
	kind = "",
}

function sym_item:tips()
	return string.format("%-4d %-12s", self.line, self.kind)
end

function sym_item:searched_str()
	return self.text
end

function sym_item:do_item()
	return true, function()
		vim.api.nvim_win_set_cursor(0, {self.line + 1, self.col})
	end
end

function sym_item:new(sym)
	setmetatable(sym, {__index = self})
	return sym
end

function M.search()
	local symbols = require'ts_ext'.get_all_context()
	if not symbols then
		nvim.util.echo({"no symbols finded", "Error"})
		return
	end

	local items = {}
	for _, sym in ipairs(symbols) do
		table.insert(items, sym_item:new(sym))
	end

	if vim.tbl_isempty(items) then
		return
	end

	require("easy_search.ui").new(items)
end

return M
