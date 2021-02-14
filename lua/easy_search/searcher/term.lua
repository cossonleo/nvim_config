
local term_item = {
	desc = "",
	buf = 0,
}

function term_item:tips()
	return string.format("%-5d", self.buf)
end

function term_item:searched_str()
	return self.desc
end

function term_item:do_item()
	return true, function()
		if self.desc == "new" and self.buf == 0 then
			vim.cmd("FloatermNew")
			return
		end

		local cmd = "call floaterm#terminal#open_existing(" .. self.buf .. ")"
		vim.cmd(cmd)
	end
end

function term_item:new(buf)
	local desc = "new"
	if buf > 0 then
		desc = vim.fn.bufname(buf)
	end
	local item = {buf = buf, desc = desc}
	setmetatable(item, {__index = self})
	return item
end

local M = {}

function M.search()
	local items = {}

	local list = vim.api.nvim_list_bufs()
	for _, buf in ipairs(list) do
		local t = vim.api.nvim_buf_get_option(buf, "filetype")
		local bt = vim.api.nvim_buf_get_option(buf, "buftype")
		if t == "floaterm" and bt == "terminal" then
			table.insert(items, term_item:new(buf))
		end
	end
	table.insert(items, term_item:new(0))

	require("easy_search.ui").new(items)
end

return M
