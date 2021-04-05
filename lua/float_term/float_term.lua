

local M = {
	buf_id = 0,
	win_id = 0,
}

local function win_option()
	local temp = conf or {area = {0.7, 0.7}, pos = {0.2, 0.2}}
	temp.pos = temp.pos or {0.2, 0.2}
	temp.area = temp.area or {0.7, 0.7}
	
	local lines = vim.o.lines
	local columns = vim.o.columns

	local row = math.ceil(temp.pos[1] * lines / 2)
	local col = math.ceil(temp.pos[2] * columns / 2)
	local width = math.ceil(temp.area[2] * columns)
	local height = math.ceil(temp.area[1] * lines)

	return {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		border = "single"
	}
		
end

function M:init_win_id()
	self.win_id = vim.api.nvim_open_win(self.buf_id, true, win_option())
	vim.api.nvim_win_set_option(self.win_id, "number", false)
	vim.api.nvim_win_set_option(self.win_id, "relativenumber", false)
	vim.api.nvim_win_set_option(self.win_id, "signcolumn", "auto:3")
	vim.api.nvim_win_set_option(self.win_id, "wrap", false)
	vim.api.nvim_win_set_option(self.win_id, "winhl", "Normal:NormalTerm")
end

function M:init_term_buf()
	self.buf_id = vim.api.nvim_create_buf(false, true)
end

function M:new_float_term()
	if self.buf_id == 0 then
		self:init_term_buf()
	end

	if self.win_id == 0 then
		self:init_win_id()
	end

	vim.cmd[[terminal]]
	vim.cmd[[startinsert!]]
end

function M:close_float_term()
	vim.api.nvim_win_close(self.win_id, true)
end

function M:toggle_float_term()
	if self.win_id == 0 then
		self:new_float_term()
		return
	end

	if not vim.api.nvim_win_is_valid(self.win_id) then
		self:init_win_id()
		vim.cmd[[startinsert!]]
		return
	end

	self:close_float_term()
end

return M
