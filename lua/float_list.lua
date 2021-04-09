
vim.fn.sign_define("list_sign_search", {text = "≡", texthl = "LineNr", linehl = "LineNr"})
vim.fn.sign_define("list_sign_select", {text = "→", texthl = "LineNr", linehl = "LineNr"})

local function create_float_win(buf)
	local win = vim.api.nvim_open_win(buf, true, {})
	return win
end

local function create_buf()
	local buf = vim.api.nvim_create_buf(false, true)
	return buf
end

local view_data = {
	data = {},
	scroll_value = 0, -- 0-based
	view_size = 0,
}

function view_data:new(data, view_size)
	local o = {
		data = data,
		scroll_value = 0,
		view_size = view_size,
	}

	setmetatable(o, {__index = self})
	return o
end

function view_data:view()
	local rows = {}
	local len = math.min(self.view_size, #self.data)
	for i = 1, len do
		table.insert(rows, self.data[self.scroll_value + i])
	end
	return rows
end

function view_data:scroll_down()
	if self.scroll_value + self.view_size < #self.data then
		self.scroll_value = self.scroll_value + 1
		return true
	end
	return false
end

function view_data:scroll_up()
	if self.scroll_value > 0 then
		self.scroll_value = self.scroll_value - 1
		return true
	end
	return false
end

local spec_key = {
}

local Widget = {
	data = {},
	buf = 0,
	win = 0,
	input = "",
	key_map = {},
	is_run = false,
}

function Widget:new(data, ext_key)
	local o = {
		data = data,
		buf = create_buf(),
		win = 0,
		input = "",
		key_map = {},
		is_run = false,
	}
	setmetatable(o, {__index = self})
	self:reset(data, ext_key)
	return o
end

function Widget:reset(data, ext_key)
	self.data = data
	self.input = ""
	self:init_key_map(ext_key)
	self:refresh_buf()
end

function Widget:init_key_map(ext_key)
	local spec_key = nl_global.spec_key
	local key_map = {
		[spec_key.esc] = function() self:close_win(); return false end,
		[spec_key.cr] = function() self:do_item(); return false end,
		[spec_key.c_j] = function() self:move_next(); return true end,
		[spec_key.c_k] = function() self:move_pre(); return true end,
	}
	if ext_key then vim.tbl_extend(key_map, ext_key, "force") end
	self.key_map = key_map
end

function Widget:refresh_buf()
	
end

function Widget:search()

end

function Widget:do_item()
	self:close_win()

	-- TODO
end

function Widget:move_next()

end

function Widget:move_pre()

end

function Widget:close_win()
	if self.win == 0 or not vim.api.nvim_win_is_valid(self.win) then
		return
	end

	vim.api.nvim_win_close(self.win)
	self.win = 0
end

function Widget:handle_input(c)
	local key_handle = self.key_map[c]
	if key_handle then return key_handle() end
	self.input = self.input .. c
	self:search()
	return true
end

function Widget:run()
	if self.win == 0 or not vim.api.nvim_win_is_valid(self.win) then
		self.win = create_float_win(self.buf)
	end

	self.is_run = true
	while(self.is_run) do
		local c = vim.fn.getchar()
		c = vim.fn.nr2char(c)
		self.is_run = self:handle_input(c)
	end
end

local M = {
	widget = nil,
}

-- create: 是否复用上一个的widget
function M.new(data, key_map, create)
	if create or M.wdiget == nil then
		M.widget = widget:new(data, key_map)
	else
		M.widget:reset(data, key_map)
	end

	M.widget:run()
end

function M.re_run()
	M.widget:run()
end

return M
