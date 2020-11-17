local M = {}

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

function new(data, loc)
	local item = {data = data, loc = loc}
	setmetatable(item, {__index = item_base})
	return item
end

function M.test()
	local vec = {}
	table.insert(vec, new("aaa", "f1:100"))
	table.insert(vec, new("bbb", "f2:100"))
	table.insert(vec, new("ccc", "f3:100"))
	ui.new(vec)
end

return M
