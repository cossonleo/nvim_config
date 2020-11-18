local M = {}
local  uv = vim.loop

local grep_item = {
	file = ""
	line = ""
	col = ""
	content = ""
}

function grep_item:tips()
	return self.file .. " " .. self.line
end

function grep_item:data_for_match()
	return self.content
end

function grep_item:do_item()
	vim.cmd(":edit " .. self.file)
	local win_id = vim.api.nvim_get_currrent_win()
	vim.api.nvim_win_set_cursor(win_id, {self.line + 1, self.col})
end

function M.grep(word)
	local files = require("easyfind/utils").scan_dir_rec()
	local function read_file(file)
	end

	local function  grep_file(content)
	end

	local work = uv.new_work(read_file, grep_File)
	for _, f in ipairs(files) do
		work:queue(f)
	end
end

return M
