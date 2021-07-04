local M = {}

local ignore_path = {
	"/%.[%w_]*$",
	{"%s/../go.mod", "/vendor$"},
	{"%s/../Cargo.toml", "/target$", "/vendor$"},
	{"%s/../init.lua", "/plugged$"},
	{"%s/../init.lua", "/coc$"},
}

nvim.is_ignore_path = function(path)
	if not ignore_path then
		return false
	end

	local and_find = function(a)
		local f = io.open(string.format(a[1], path))
		if not f then return false end
		f:close()
		
		for i = 2, #a do
			local s = path:find(a[i])
			if s then return true end
		end
		return false
	end

	for _, m in ipairs(ignore_path) do
		local t = type(m)
		if t == "string" then
			local s = path:find(m)
			if s then
				return true
			end
		elseif t == "table" then
			if and_find(m) then
				return true
			end
		end
	end
	return false
end
