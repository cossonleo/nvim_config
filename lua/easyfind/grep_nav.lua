local M = {}

local  uv = vim.loop

local grep_item = {
	file = "",
	line = "",
	col = "",
	content = "",
}

function grep_item:tips()
	return "[" .. self.file .. ":" .. self.line .. "]"
end

function grep_item:data_for_match()
	return self.content
end

function grep_item:do_item()
	vim.cmd(":edit " .. self.file)
	local win_id = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_cursor(win_id, {self.line + 1, self.col})
end

function grep_item:new(file, line, col, content)
	local item = {file = file, line = line, col = col, content = content}
	setmetatable(item, {__index = self})
	return item
end

function M.grep(word)
	if not word or #word == 0 then return end

	local path = vim.fn.getcwd(-1, 0)
	local files = require("easyfind/utils").scan_dir_rec(path)

	local len = 0
	local items = {}
	local total_file = #files
	local function  grep_file(file, content)
		if content then
			local lines = vim.split(content, "\n", false)
			for i, line in ipairs(lines) do
				local start = string.find(line, word, 1, true)
				if start then 
					local item = grep_item:new(file:sub(#path + 2), i - 1, start - 1, line)
					table.insert(items, item)
				end
			end
		end

		len = len + 1
		if len >= #files then
			vim.schedule(function()
				require("easyfind/ui").new(items)
			end)
		end
	end

	local function read_file(file)
		uv.fs_open(file, "r", 438, function(err, fd)
			if err then grep_file(file, nil); return end
			uv.fs_fstat(fd, function(err, stat)
				if err then grep_file(file, nil); return end
				uv.fs_read(fd, stat.size, 0, function(err, data)
					if err then grep_file(file, nil); return end
					uv.fs_close(fd, function(err)
						if err then vim.cmd[[echoerr "file close err"]] end
						grep_file(file, data)
					end)
				end)
			end)
		end)
		--local luv = require("luv")
		--local fd = luv.fs_open(file, "r", 438)
		--if not fd then return file, nil end
		--local stat = luv.fs_fstat(fd)
		--if not stat then luv.fs_close(fd); return file, nil end
		--local data = luv.fs_read(fd, stat.size, 0)
		--luv.fs_close(fd)
		--return file, data
		--return "", ""
	end

	for _, f in ipairs(files) do
		read_file(f)
	end
	--local work = uv.new_work(read_file, grep_file)
	--for _, f in ipairs(files) do
	--	work:queue(f)
	--end
end

return M
