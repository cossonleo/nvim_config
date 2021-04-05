
local function win_option()
	local lines = vim.o.lines
	local columns = vim.o.columns

	local row = math.ceil(0.1 * lines / 2)
	local col = math.ceil(0.2 * columns / 2)
	local width = math.ceil(0.7 * columns)
	local height = math.ceil(0.7 * lines)

	return {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		border = "single"
	}
		
end

local function init_float_win(buf_id)
	local win_id = vim.api.nvim_open_win(buf_id, true, win_option())
	vim.api.nvim_win_set_option(win_id, "number", false)
	vim.api.nvim_win_set_option(win_id, "relativenumber", false)
	vim.api.nvim_win_set_option(win_id, "signcolumn", "auto:3")
	vim.api.nvim_win_set_option(win_id, "wrap", false)
	vim.api.nvim_win_set_option(win_id, "winhl", "Normal:NormalTerm")
	return win_id
end

local FloatTerm = {
	buf_id = 0,
	win_id = 0,
}

function FloatTerm:toggle()
	if self.win_id == 0 or 
		not vim.api.nvim_win_is_valid(self.win_id) 
	then
		self.win_id = init_float_win(self.buf_id)
		vim.cmd[[startinsert!]]
		return
	end

	local cur_win = vim.api.nvim_get_current_win()
	if cur_win ~= self.win_id then return end
	vim.api.nvim_win_close(0, true)
	self.win_id = 0
end

function new_float_term()
	local buf_id = vim.api.nvim_create_buf(false, true)
	local win_id = init_float_win(buf_id)

	--local shell = vim.fn.getenv("SHELL")
	--vim.fn.termopen(shell, {})
	vim.cmd[[terminal]]
	vim.cmd[[startinsert!]]

	local o = {buf_id = buf_id, win_id = win_id}
	setmetatable(o, {__index = FloatTerm})
	return o
end

return {new = new_float_term}
