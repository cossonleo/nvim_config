
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

local function new_float_term()
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

function FloatTerm:close_win()
	local win_valid = self.win_id > 0 and vim.api.nvim_win_is_valid(self.win_id)
	if win_valid then
		vim.api.nvim_win_close(0, true)
	end
	self.win_id = 0
	return win_valid
end

function FloatTerm:toggle()
	local buf_valid = self.buf_id > 0 and vim.api.nvim_buf_is_valid(self.buf_id)
	if not buf_valid then
		if self:close_win() then return end
		local n = new_float_term()
		self.buf_id = n.buf_id
		self.win_id = n.win_id
		return
	end

	if self.win_id > 0 and vim.api.nvim_win_is_valid(self.win_id) then
		self:close_win()
		return
	end

	self.win_id = init_float_win(self.buf_id)
	vim.cmd[[startinsert!]]
end

return {new = new_float_term}
