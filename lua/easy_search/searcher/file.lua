local file_item = {
	name = "",
	win = 0,
}

function file_item:tips()
	return ""
end

function file_item:searched_str()
	return self.name
end

function file_item:do_item()
	return true, function()
		local buf = vim.fn.bufnr(self.name)
		if buf == -1 then
			vim.cmd("edit " .. self.name)
			return
		end

		local wid = vim.fn.bufwinid(buf)
		if wid > 0 then
			vim.api.nvim_set_current_win(wid)
			return
		end

		vim.api.nvim_set_current_buf(buf)
	end
end

function file_item:new(name, win)
	local item = {name = name, win = win}
	setmetatable(item, {__index = self})
	return item
end

local function generate_items(files)
	local win = vim.api.nvim_get_current_win()
	local items = {}
	for _, f in ipairs(files) do
		local item = file_item:new(f, win)
		table.insert(items, item)
	end
	require("easy_search.ui").new(items)
end

local function collect_by_rg()
	local pwd = vim.fn.getcwd(-1, 0)
	local cmd = "rg --files " .. pwd
	local t = io.popen(cmd)
	local str = t:read("*a")
	if #str == 0 then return end
	local files = {}
	local start = #pwd + 2
	for p in vim.gsplit(str, "\n") do
		local f = p:sub(start)
		if #f > 0 then
			table.insert(files, f)
		end
	end
	generate_items(files)
end

local function collect_by_builtin()
	local pwd = vim.fn.getcwd(-1, 0)
	local paths = require("share_sugar").scan_dir_rec(pwd, true) 
	local files = {}
	for _, file in ipairs(paths) do
		table.insert(files, file:sub(#pwd + 2))
	end
			local sub = p:sub(#pwd + 2)
	generate_items(files)
end

return {
	search = function() 
		if vim.fn.executable("rg") == 1 then
			collect_by_rg()
		else
			collect_by_builtin()
		end
	end
}
