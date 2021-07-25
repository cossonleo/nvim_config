nvim.call_once = function(f)
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

nvim.echo = function(...)
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

-- 是否符合首字母模糊匹配
nvim.fuzzy_match = function(str, pattern)
	local slen = str:len()
	local plen = pattern:len()
	local n = 1
	local sort_num = {}
	for i = 1, plen do
		local pc = pattern:sub(i, i)
		local count = (slen - n) - (plen - i)
		if count < 0 then return nil end
		local find = true
		for j = 0, count do
			local index = n + j
			local sc = str:sub(index, index)
			if sc == pc then
				table.insert(sort_num, index)
				n = index + 1
				goto find_label 
			end
		end
		find = false
		::find_label::
		if not find then return nil end
	end
	return sort_num
end
