nvim.util = nvim.util or {}
nvim.util.call_once = function(f)
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

nvim.util.echo = function(...)
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

nvim.util.buf_path = function()
	return require'nvim_eutil.file'.file_name()
end

nvim.util.cur_file_size = function()
	local cur_path = vim.fn.expand('%')
	return require'nvim_eutil.file'.file_size(cur_path)
end
