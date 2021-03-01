nvim_utils.call_once = function(f)
	local called = false
	local ret = nil 
	return function()
		if called then 
			if ret then
				return unpack(ret)
			else
				return nil
			end
		end

		called = true
		local temp = { f() }
		if #temp == 0 or #temp[1] == nil then
			return
		end
		ret = temp
		return unpack(ret)
	end
end

nvim_utils.echo = function(...)
	local args = { ... }
	local texts = {}
	for _, arg in ipairs(args) do
		local t = type(arg)
		if t == "string" then
			table.insert(texts, {t})
		elseif t == "table" then
			table.insert(texts, t)
		end
	end
	vim.api.nvim_echo(texts, false, {})
end

