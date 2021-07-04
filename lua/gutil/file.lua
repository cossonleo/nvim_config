nvim.get_file_size = function (path)
	local size = vim.fn.getfsize(path)
	if size <= 0 then
		return ""
	end

	if size < 1024 then
		return tostring(size) .. 'B'
	elseif size < 1024*1024 then
		return string.format('%.1f', size/1024.0) .. 'K'
	elseif size < 1024*1024*1024 then
		return string.format('%.1f', size/1024.0/1024.0) .. 'M'
	else
		return string.format('%.1f', size/1024.0/1024.0/1024.0) .. 'G'
	end

	return ""
end

nvim.get_cur_file_size = function()
	local cur_path = vim.fn.expand('%')
	return nvim.get_file_size(cur_path)
end

local function path_relative(path, cmp)
	local pelems = vim.split(path, "/", true)
	local celems = vim.split(cmp, "/", true)

	local index = 0
	local len = #celems
	if #pelems < len then len = #pelems end
	repeat 
		index = index + 1
	until (index > len or pelems[index] ~= celems[index])

	if index > len then
		return path
	end

	local rela = {}
	for i = index, #celems do
		table.insert(rela, "..")
	end
	for i = index, #pelems do
		table.insert(rela, pelems[i])
	end
	local new = table.concat(rela, "/")
	if #new > #path then new = path end
	return new
end

nvim.get_cur_buf_name = function()
	local path = vim.fn.expand('%:p')
	local cwd = vim.fn.getcwd()
	if vim.startswith(path, cwd) then
		return path:sub(#cwd + 2)
	end
	return path_relative(path, cwd)
	--local len = 50
	--local plen = #path
	--if plen <= len then return path end
	--local elems = {}
	--local start = 2
	--repeat
	--	local pos = path:find("/", start)
	--	if not pos then break end
	--	table.insert(elems, path:sub(start, start))
	--	plen = plen - (pos - start - 1)
	--	start = pos + 1
	--until(plen <= len)
	--table.insert(elems, path:sub(start))
	--local new = table.concat(elems, "/")
	--return "/" .. new
end
