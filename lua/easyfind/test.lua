local M = {}
local uv = vim.loop

local ui = require("easyfind/ui")

local item_base = {
	data = "",
	loc = "",
}

function item_base:get_loc()
	return self.loc
end

function item_base:get_data()
	return self.data
end

function item_base:do_item()
	print("aaaa", self.data, self.loc)
end

function new(data, loc)
	local item = {data = data, loc = loc}
	setmetatable(item, {__index = item_base})
	return item
end

function M.test()
	local vec = {}
	local fd = uv.fs_opendir(".")
	for i = 1, 8 do
		local iter = uv.fs_readdir(fd)
		if iter then
			for _, d in ipairs(iter) do
				table.insert(vec, new(d.name, ""))
			end
		end
	end
	ui.new(vec)
end

return M
