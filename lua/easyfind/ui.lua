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
	if not vim.api.nvim_win_is_valid(win_id) then return end
	vim.api.nvim_win_close(win_id, true)
	win_id = 0
end

local function init_buf_once()
	if buf_id > 0 then return end

	buf_id = vim.api.nvim_create_buf(false, true)
	if buf_id == 0 then
		vim.cmd[[echoerr "create buf false"]]
		return
	end

	vim.api.nvim_buf_set_option(buf_id, "buftype", "nofile")
	--vim.api.nvim_buf_set_option(buf_id, "bufhidden", "delete")
	vim.api.nvim_buf_set_option(buf_id, "swapfile", false)

	local next_cmd = "<c-o>:lua require'easyfind/ui'.move_next()<cr><cr>"
	local pre_cmd = "<c-o>:lua require'easyfind/ui'.move_pre()<cr><cr>"
	local do_cmd = "<c-o>:lua require'easyfind/ui'.do_item()<cr><cr>"
	local close = "<c-o>:lua require'easyfind/ui'.close()<cr><cr>"
	local opts = {noremap = true}
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<c-j>", next_cmd, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<c-k>", pre_cmd, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<cr>", do_cmd, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<esc>", close, opts)
end

local function open_win()
	close_win()
	win_id = vim.api.nvim_open_win(buf_id, true, { 
		relative = "editor",
		row = show_conf.row,
		col = show_conf.col,
		width = show_conf.width,
		height = show_conf.height,
	})
	vim.api.nvim_win_set_cursor(win_id, {1, 0})
end

local function set_conf(conf)
	local temp = conf or {area = {0.7, 0.7}, pos = {0.2, 0.2}}
	temp.pos = temp.pos or {0.2, 0.2}
	temp.area = temp.area or {0.7, 0.7}
	
	local lines = vim.o.lines
	local columns = vim.o.columns

	local row = math.ceil(temp.pos[1] * lines / 2)
	local col = math.ceil(temp.pos[2] * columns / 2)
	local width = math.ceil(temp.area[2] * columns)
	local height = math.ceil(temp.area[1] * lines)
	show_conf = {row = row, col = col, width = width, height = height}
end

local function filter(data, filter)
	return true
end

local function set_show_vec(filter_text)
	if not filter_text then
		local lines = vim.api.nvim_buf_get_lines(buf_id, 0, 1, false)
		filter_text = #lines > 0 and lines[1] or ""
	end

	show_vec = {}
	for i, item in ipairs(data_vec) do
		if filter(item:get_data(), filter_text) then
			table.insert(show_vec, i)
		end
	end
	first_index = 0
	offset = 0
end

local function set_buf()
	init_buf_once()
	local lines = {""}
	local count = show_conf.width - 1
	for i = 1, count do
		local index = i + first_index
		if index > #show_vec then break end
		local data_index = show_vec[index]
		local item = data_vec[data_index]
		table.insert(lines, item:get_loc() .. ":" .. item:get_data())
	end
	vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
	-- set hi
end

local function new(data, conf)
	data_vec = data
	set_conf(conf)
	set_show_vec("")
	set_buf()
	open_win()
end

local function add(data)
	data_vec = vim.list_extend(data_vec, data)
end

local function move_next()
end

local function move_pre()

end

local function do_item()
end

M.new = function(data, conf) new(data, conf) end
M.move_next = function() move_next() end
M.move_pre = function() move_pre() end
M.do_item = function() do_item() end
M.close = function() close_win() end

return M
