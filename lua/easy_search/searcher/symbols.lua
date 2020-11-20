local M = {}

local sym_item = {
	line = 0,
	col = 0,
	text = "",
}

function sym_item:tips()
	return string.format("%-5d", self.line)
end

function sym_item:searched_str()
	return self.text
end

function sym_item:do_item()
	vim.api.nvim_win_set_cursor(0, {self.line + 1, self.col})
end

function sym_item:new(line, col, text)
	local item = {line = line, col = col, text = text}
	setmetatable(item, {__index = self})
	return item
end

local function prepare_func_match(entry, kind)
	local entries = {}

	if entry.node then
		if kind == "function" or 
			kind == "method" or 
			kind == "type" or 
			kind == "macro" or 
			kind == "namespace" 
		then
			entry["kind"] = kind
			table.insert(entries, entry)
		end
	else
		for name, item in pairs(entry) do
				vim.list_extend(entries, prepare_func_match(item, name))
		end
	end

	return entries
end

function M.search()
	local has_nvim_treesitter, _ = pcall(require, 'nvim-treesitter')
	if not has_nvim_treesitter then
		return
	end

	local parsers = require('nvim-treesitter.parsers')
	if not parsers.has_parser() then
		return
	end

	local ts_locals = require('nvim-treesitter.locals')
	local bufnr = vim.api.nvim_get_current_buf()

	local items = {}
	for _, definitions in ipairs(ts_locals.get_definitions(bufnr)) do
		local entries = prepare_func_match(definitions)
		for _, entry in ipairs(entries) do
			local start_row, start_col, end_row, end_col = entry.node:range()
			local texts = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
			local text = table.concat(texts)
			table.insert(items, sym_item:new(start_row, start_col, text))
		end
	end

	if vim.tbl_isempty(items) then
		return
	end

	require("easy_search/ui").new(items)
end

return M
