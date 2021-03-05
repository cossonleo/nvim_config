local file_item = {
	name = "",
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

function file_item:new(name)
	local item = {name = name}
	setmetatable(item, {__index = self})
	return item
end

local function generate_items(files)
	local items = {}
	for _, f in ipairs(files) do
		local item = file_item:new(f)
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
		if not require"path_ignore".is_ignore(p) then
			local f = p:sub(start)
			if #f > 0 then
				table.insert(files, f)
			end
		end
	end
	generate_items(files)
end

local function collect_by_builtin()
	local pwd = vim.fn.getcwd(-1, 0)
	local paths = require("share_sugar").scan_dir_rec(pwd, true) 
	local files = {}
	for _, file in ipairs(paths) do
		if not require"path_ignore".is_ignore(file) then
			table.insert(files, file:sub(#pwd + 2))
		end
	end
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
