
local a = vim.api
local path_ignore = require("path_ignore")

local M = {}

-- (row, col) -- 0-based
function M.get_cur_pos(buf)
	local b = buf or 0
	local pos = a.nvim_win_get_cursor(b)
	return {pos[1] - 1, pos[2]}
end

function M.buf_id()
	return a.nvim_get_current_buf()
end

-- [start(row, col), end(row, col))
-- 0-based index
function M.get_lines(buf, start, end_)
	local lines = vim.api.nvim_buf_get_lines(buf, start[1], end_[1] + 1, false)
	if #lines == 0 then return lines end
	if #lines == end_[1] - start[1] + 1 then
		lines[#lines] = lines[#lines]:sub(1, end_[2])
	end
	if #lines[#lines] == 0 then
		table.remove(lines)
		return lines
	end
	lines[1] = lines[1]:sub(start[2] + 1)
	return lines
end

-- 递归扫描目录
function M.scan_dir_rec(path, ignore)
	local uv = vim.loop

	if not path or #path == "" then
		return {}
	end

	local dir = uv.fs_opendir(path, nil, 1000)
	if not dir then return end

	local vec = {}
	local sub_dir = {}
	local readdir = function()
		local iter = uv.fs_readdir(dir)
		if not iter or #iter == 0 then 
			uv.fs_closedir(dir)
			return true
		end
		for _, entry in ipairs(iter) do
			local p = path .. "/" .. entry.name
			if not ignore or not path_ignore.is_ignore(p) then
				if entry.type == "file" then
					table.insert(vec, p)
				elseif entry.type == "directory" then
					table.insert(sub_dir, p)
				end
			end
		end
		return false
	end

	repeat
		local tail = readdir()
	until tail

	for _, sd in ipairs(sub_dir) do
		local sub_f = M.scan_dir_rec(sd, ignore)
		vec = vim.list_extend(vec, sub_f)
	end
	return vec
end

-- 是否符合首字母模糊匹配
M.fuzzy_match = function(str, pattern)
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

return M
