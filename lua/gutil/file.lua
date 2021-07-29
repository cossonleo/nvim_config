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

-- 递归扫描目录
local function _scan_dir_rec(path, ignore)
	local uv = vim.loop

	if not path or #path == "" then return {} end
	local vec = {}
	local sub_dir = {}

	local dir_iter = uv.fs_scandir(path)
	if not dir_iter then return vec end
	while (true) do
		local entry, type = uv.fs_scandir_next(dir_iter)
		if not entry then break end
		local p = path .. "/" .. entry
		if not ignore or not nvim.is_ignore_path(p) then
			if type == "file" then
				table.insert(vec, p)
			elseif type == "directory" then
				table.insert(sub_dir, p)
			end
		end
	end

	-- 下面过程会发生coredump， 原因 调用closedir报duoble free错误
	--local dir = uv.fs_opendir(path, nil, 1000)
	--if not dir then return vec end

	--while (true) do
	--	local entries = dir:readdir()
	--	if not entries then break end
	--	for _, entry in ipairs(entries) do
	--		local p = path .. "/" .. entry.name
	--		if not ignore or not nvim.is_ignore_path(p) then
	--			if entry.type == "file" then
	--				table.insert(vec, p)
	--			elseif entry.type == "directory" then
	--				table.insert(sub_dir, p)
	--			end
	--		end
	--	end
	--end
	--dir:closedir()

	for _, sd in ipairs(sub_dir) do
		local sub_f = _scan_dir_rec(sd, ignore)
		vec = vim.list_extend(vec, sub_f)
	end
	return vec
end

nvim.scan_dir_rec = _scan_dir_rec
