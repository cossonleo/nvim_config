local M = {}

local grep_item = {
	file = "",
	line = "",
	col = "",
	content = "",
}

function grep_item:tips()
	return "[" .. self.file .. ":" .. self.line .. "]"
end

function grep_item:searched_str()
	return self.content
end

function grep_item:do_item()
	return true, function()
		vim.cmd(":edit " .. self.file)
		local win_id = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_cursor(win_id, {self.line + 1, self.col})
	end
end

function grep_item:new(file, line, col, content)
	local item = {file = file, line = line, col = col, content = content}
	setmetatable(item, {__index = self})
	return item
end

local function grep(word)
	if not word or #word == 0 then return end
	local uv = vim.loop

	local path = vim.fn.getcwd(-1, 0)
	local files = require("share_sugar").scan_dir_rec(path, true)
	if #files == 0 then return end

	local grep_op = {
		files = files,
		finish = 0,
		total = #files,
		items = {}
	}

	function grep_op:search_line(file, content)
		if content then
			local lines = vim.split(content, "\n", false)
			for i, line in ipairs(lines) do
				local start = string.find(line, word, 1, true)
				if start then 
					local item = grep_item:new(file:sub(#path + 2), i - 1, start - 1, line)
					table.insert(self.items, item)
				end
			end
		end

		self.finish = self.finish + 1
		if self.finish >= self.total then
			vim.schedule(function()
				require("easy_search.ui").new(self.items)
			end)
		end
	end

	function grep_op:read_file(file)
		uv.fs_open(file, "r", 438, function(err, fd)
			if err then 
				self:search_line(file, nil); 
				self:pop()
				return 
			end

			uv.fs_fstat(fd, function(err, stat)
				if err then 
					uv.fs_close(fd, function(err) end)
					self:search_line(file, nil); 
					self:pop()
					return 
				end

				uv.fs_read(fd, stat.size, 0, function(err, data)
					if not err then
						self:search_line(file, data)
					end
					uv.fs_close(fd, function(err)
						self:pop()
					end)
				end)
			end)
		end)
	end

	function grep_op:pop()
		if #self.files == 0 then return end
		local f = self.files[#self.files]
		self:read_file(f)
		table.remove(self.files)
	end

	local lcount = #grep_op.files < 1000 and #grep_op.files or 1000
	for i = 1, lcount do
		grep_op:pop()
	end
end

local function grep_new(word)
	if not word or #word == 0 then return end

	local path = vim.fn.getcwd(-1, 0)
	local files = require("share_sugar").scan_dir_rec(path)

	local len = 0
	local items = {}
	local total_file = #files

	local function  grep_file(file, one)

		len = len + 1
		if len >= total_file then
			vim.schedule(function()
				--require("easy_search/ui").new(items)
				print("finish")
			end)
		end
	end

	local function read_file(file, pat)
		local luv = require("luv")
		local fd = luv.fs_open(file, "r", 438)
		if not fd then return nil end
		local stat = luv.fs_fstat(fd)
		if not stat then luv.fs_close(fd); return nil end
		local data = luv.fs_read(fd, stat.size, 0)
		luv.fs_close(fd)

		local one_items = {}
		local start = 1
		local row = 0
		repeat
			local e = data:find("\n", start)
			local line = data:sub(start, e)
			if e then
				if #line > #pat then 
					local ss = string.find(line, pat, 1, true)
					if ss then
						local item = row .. "|" .. (start - 1) .. "|" .. line
						table.insert(one_items, item)
					end
				end
			end
			start = e and e + 1 or 0
			row = row + 1
		until(start == 0)
		return file, table.concat(one_items)
	end

	local work = vim.loop.new_work(read_file, grep_file)
	for _, f in ipairs(files) do
		work:queue(f, word)
	end
end

function easy_search_grep_hl(cmd)
	return {{0, #cmd, 'Function'}}
end

function M.search()
	local default = vim.fn.expand('<cword>')
	function easy_search_grep_completion(A, L, P)
		return {default}
	end

	vim.cmd "echohl Error"
	vim.fn.inputsave()
	local input = vim.fn.input({
		prompt = 'rg> ',
		highlight = easy_search_grep_hl,
		completion="customlist,v:lua.easy_search_grep_completion"
	})
	vim.fn.inputrestore()
	vim.cmd "echohl None"

	if #input == 0 then
		vim.cmd[[echo "no input for grep"]]
		return 
	end
	grep(input)
	--grep_new(input)
end

return M
