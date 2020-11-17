local M = {}

local data_vec = {}
local show_vec = {}
local first_index = 0
local offset = 0

local buf_id = 0
local win_id = 0
local show_conf = {}

local function close_win()
	if win_id == 0 then return end

end

local function open_win()
	if buf_id == 0 then
		buf_id = vim.api.nvim_create_buf(false, false)
	end

	if buf_id == 0 then
		vim.cmd[[echoerr "create buf false"]]
		return
	end

	close_win()

	win_id = vim.api.nvim_open_win(buf_id, true, { 
		relative = "editor",
		row = show_conf.row,
		col = show_conf.col,
		width = show_conf.width,
		height = show_conf.height,
	})
end

local function show(conf)
	local temp = conf or {area = {0.7, 0.7}, pos = {0.2, 0.2}}
	temp.pos = temp.pos or {0.2, 0.2}
	temp.area = temp.area or {0.7, 0.7}
	
	local lines = vim.o.lines
	local columns = vim.o.columns

	local row = temp.pos[1] * lines / 2
	local col = temp.pos[2] * columns / 2
	local width = temp.area[2] * columns
	local height = temp.area[1] * lines
	show_conf = {row = row, col = col, width = width, height = height}
	open_win()
end

local function filter(data, filter)
	return true
end

local function set_buf()
	show_vec = {}
	local lines = {""}
	local count = 0
	for i, item in ipairs(data_vec) do
		if #lines >= show_conf.area[1] then
			break
		end

		local line = item.location() .. item.get_data()
		table.insert(lines, line)
		table.insert(show_vec, i)
		count = count + 1
	end

	first_index = 0
	offset = 0
	vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
	vim.api.nvim_win_set_cursor(win_id, {1, 0})
end

local function new(data)
	data_vec = data
end

local function add(data)
	data_vec = vim.list_extend(data_vec, data)
end

return M
