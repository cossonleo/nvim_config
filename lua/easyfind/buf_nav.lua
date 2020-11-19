local M = {}

local buf_item = {
	buf_id = 0,
	buf_name = "",
}

function buf_item:tips()
	return self.buf_id .. ": "
end

function buf_item:data_for_match()
	return self.buf_name
end

function buf_item:do_item()
	vim.api.nvim_win_set_buf(0, self.buf_id)
end

function buf_item:new(buf, name)
	local item = {buf_id = buf, buf_name = name}
	setmetatable(item, {__index = self})
	return item
end

function M.buf_list()
	local list = vim.api.nvim_list_bufs()
	if not list or #list == 0 then return end

	local function check(buf)
		if vim.fn.bufwinid(buf) > 0 then return false end
		if vim.fn.bufexists(buf) <= 0 then return false end
		if vim.fn.bufloaded(buf) <= 0 then return false end
		if vim.fn.buflisted(buf) <= 0 then return false end
		local name = vim.fn.bufname(buf)
		if not name or name == "" then return false end
		return name
	end

	local items = {}
	local last_buf = vim.fn.bufnr('#')
	local cur_win = vim.api.nvim_get_current_win()

	local name = check(last_buf)
	if name then
		table.insert(items, buf_item:new(last_buf, name)) 
	end

	for _, buf in ipairs(list) do
		if last_buf ~= buf then
			local name = check(buf)
			if name then 
				table.insert(items, buf_item:new(buf, name)) 
			end
		end
	end

	if #items == 0 then return end
	require("easyfind/ui").new(items)
end

return M
