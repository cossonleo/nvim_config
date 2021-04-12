local fuzzy_match  = require("share_sugar").fuzzy_match

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

function view_data:resize(view_size)
	if view_size == self.view_size then return end
	self.view_size = view_size
	local data_len #self.data
	if self.scroll_value + view_size > data_len then
		self.scroll_value = view_size > data_len and 0 or data_len - view_size
	end
end

function view_data:cur_data(cur_line)
	return self.data[self.scroll_value + cur_line + 1]
end

local Widget = {
	data = {},
	buf = 0,
	win = 0,
	input = "",
	key_map = {},
	is_run = false,
	cur_line = 0, -- 0-based
}

function Widget:new(data, ext_key)
	local o = {
		data = data,
		buf = create_buf(),
		win = 0,
		input = "",
		key_map = {},
		cur_line = 0,
		is_run = false,
	}
	setmetatable(o, {__index = self})
	self:reset(data, ext_key)
	return o
end

function Widget:reset(data, ext_key)
	self.data = data
	self.input = ""
	self.cur_line = 0
	self:init_key_map(ext_key)
	self.view_data = view_data:new(data.items or data)
	self:refresh_buf()
end

function Widget:init_key_map(ext_key)
	local spec_key = nl_global.spec_key
	self.key_map = {
		[spec_key.esc] = function() self:close_win(); return false end,
		[spec_key.cr] = function() self:on_enter(); return false end,
		[spec_key.c_j] = function() self:move_next(); return true end,
		[spec_key.c_k] = function() self:move_pre(); return true end,
	}

	if not ext_key then return end
	for key, func in pairs(ext_key) do
		self.key_map[key] = function()
			return func(self:cur_data())
		end
	end
end

function Widget:refresh_buf()
	local view_items = self.view_data.view()
	local buf_lines = {self.input}
	for _, item in ipairs(view_items) do
		table.insert(buf_lines, item:tips() .. item:data_str())
	end
	
	vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, buf_lines)

	-- TODO
	-- 增加高亮
end

function Widget:search()
	self.cur_line = 0
	local show_vec = {}
	for i, item in ipairs(self.data.item) do
		if self.input == "" then
			table.insert(show_vec, {i = i})
		else
			local match_info = filter(item:searched_str(), self.input)
			if not match_info  then
				goto continue
			end

			table.insert(show_vec, {i = i, match_info = match_info})
		end
	end
	if last_match_pattern ~= "" then
		table.sort(show_vec, function(s1, s2) 
			local len = #s1.match_info
			for i = 1, len do
				local ss1, ss2 = s1.match_info[i], s2.match_info[i]
				if ss1 < ss2 then return true end
				if ss1 > ss2 then return false end
			end
			--if s1.i < s2.i then return true end
			return false
		end)
	end
	first_index = 1
	select_line = 1

	self.view_data = view_data:new(filter_data, self.lines)
	self.refresh_buf()
end


function Widget:on_enter()
	self:close_win()
	self:cur_data():on_enter()
end

function Widget:cur_data()
	return self.view_data:cur_data(self.cur_line)
end

function Widget:move_next()
	local is_bottom = self.cur_line + 1 >= self.lines
	if is_bottom and self.view_data:scroll_down() then
		self:refresh_buf()
	end
end

function Widget:move_pre()
	if self.cur_line == 0 and self.view_data:scroll_up() then
		self:refresh_buf()
	end
end

function Widget:close_win()
	if self.win == 0 then
		return
	elseif vim.api.nvim_win_is_valid(self.win) then
		vim.api.nvim_win_close(self.win)
	end

	self.win = 0
	self.lines = 0
end

function Widget:handle_input(c)
	local key_handle = self.key_map[c]
	if key_handle then return key_handle() end
	self.input = self.input .. c
	self:search()
	return true
end

function Widget:_run_rec()
	local c = vim.fn.getchar()
	c = vim.fn.nr2char(c)
	self.is_run = self:handle_input(c)
	if self.is_run then
		vim.defer_fn(self:_run_rec, 0)
	else
		self:close_win()
		if self.data.on_end and type(self.data.on_end) == "function" then
			self.data.on_end()
		end
	end
end

function Widget:run()
	if self.is_run then return end
	if self.win == 0 or not vim.api.nvim_win_is_valid(self.win) then
		self.win, self.lines = create_float_win(self.buf)
	end

	self.is_run = true
	vim.defer_fn(self:_run_rec, 0)
end

local M = {}

function M.new(data, key_map)
	return widget:new(data, key_map)
end

return M
