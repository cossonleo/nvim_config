local M = {}

local uv = vim.loop

function M.scan_dir_rec(path)
	path = path or vim.fn.getcwd(-1, 0)
	local dir = uv.fs_opendir(path, nil, 1000)
	if not dir then return end

	local vec = {}
	local sub_dir = {}
	local readdir = function()
		local iter = uv.fs_readdir(dir)
		if not iter or #iter == 0 then 
			uv.fs_closedir(dir)
			return  false
		end
		for _, entry in ipairs(iter) do
			local p = path .. "/" .. entry.name
			if entry.type == "file" then
				table.insert(vec, p)
			elseif entry.type == "directory" then
				table.insert(sub_dir, p)
			end
		end
		return true
	end

	repeat
		local continue = readdir()
	until continue

	for _, sd in ipairs(sub_dir) do
		local sub_f = scan_dir(sd)
		vec = vim.list_extend(vec, sub_f)
	end
	return vec
end

return M
