local M = {}
local fuzzy = require("easyfind/fuzzy")
local filter = fuzzy.match_and_pick_sort_str

local data_vec = {}
local show_vec = {}

-- 1-based
local first_index = 0
local select_line = 0

local buf_id = 0
local win_id = 0
local show_conf = {}

local search_sign_id = 0
local search_sign_id2 = 0
local select_sign_id = 0

vim.fn.sign_define("easyfind_sign_search", {text = ">>", texthl = "Error", linehl = "CursorLine"})
vim.fn.sign_define("easyfind_sign_search2", {text = ">", texthl = "Error", linehl = "CursorLine"})
vim.fn.sign_define("easyfind_sign_select", {text = "->", texthl = "Function", linehl = "CursorLine"})

local function close_win()
	if win_id == 0 then return end
	if not vim.api.nvim_win_is_valid(win_id) then return end
	vim.api.nvim_win_close(win_id, true)
	win_id = 0
end

local function refresh_sign()
	if select_sign_id > 0 then 
		vim.fn.sign_unplace("", {buffer = buf_id, id = select_sign_id})
	end
	select_sign_id = vim.fn.sign_place(0, "", "easyfind_sign_select", buf_id, {lnum = select_line + 1})
end

local function search_sign()
	if search_sign_id > 0 then 
		vim.fn.sign_unplace("", {buffer = buf_id, id = search_sign_id})
	end
	search_sign_id = vim.fn.sign_place(0, "", "easyfind_sign_search", buf_id, {lnum = 1})

	if search_sign_id2 > 0 then 
		vim.fn.sign_unplace("", {buffer = buf_id, id = search_sign_id2})
	end
	search_sign_id2 = vim.fn.sign_place(0, "", "easyfind_sign_search2", buf_id, {lnum = 1})
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

	local opts = {noremap = true, silent = true}
	local do_cmd = ":lua require'easyfind/ui'.do_item()<cr>"
	local close = ":lua require'easyfind/ui'.close()<cr>"
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<cr>", "<c-[>" .. do_cmd, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<esc>", "<c-[>" .. close, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "n", "<esc>", close, opts)

	--opts.expr = true
	--local next_cmd = [[luaeval("require'easyfind/ui'.move_next()")]]
	--vim.api.nvim_buf_set_keymap(buf_id, "i", "<c-j>", next_cmd, opts)
	--local pre_cmd = [[luaeval("require'easyfind/ui'.move_pre()")]]
	--vim.api.nvim_buf_set_keymap(buf_id, "i", "<c-k>", pre_cmd, opts)
	local next_cmd = "<c-o>:lua require'easyfind/ui'.move_next()<cr>"
	local pre_cmd = "<c-o>:lua require'easyfind/ui'.move_pre()<cr>"
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<c-j>", next_cmd, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<c-k>", pre_cmd, opts)
	search_sign()

	local match_atuo_cmd = "au TextChangedI <buffer=" .. buf_id .. "> lua require'easyfind/ui'.match()"
	vim.cmd(match_atuo_cmd)

	--vim.api.nvim_buf_attach(buf_id, false, {
	--	on_changedtick = function(...)
	--		vim.schedule(function()
	--			--set_show_vec(true)
	--			--set_buf(true)
	--			print("+++++++++++++++++++++")
	--		end)
	--	end
	--})
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
	vim.api.nvim_win_set_option(win_id, "number", false)
	vim.api.nvim_win_set_option(win_id, "relativenumber", false)
	--vim.api.nvim_win_set_option(win_id, "signcolumn", "auto:9")
	--vim.api.nvim_win_set_option(win_id, "signcolumn", "number")
	vim.api.nvim_win_set_option(win_id, "signcolumn", "auto:3")
	refresh_sign()

	vim.api.nvim_feedkeys("i", "n", true)
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

local function set_show_vec(on_match)
	local search_line = ""
	if on_match then
		local lines = vim.api.nvim_buf_get_lines(buf_id, 0, 1, false)
		if #lines > 0 then search_line = lines[1] end
	end

	show_vec = {}
	for i, item in ipairs(data_vec) do
		if not on_match or search_line == "" or filter(item:get_data(), search_line) then
			table.insert(show_vec, i)
		end
	end
	first_index = 1
	select_line = 1
end

local function set_buf(on_match)
	local search_line = ""
	if on_match then
		local lines = vim.api.nvim_buf_get_lines(buf_id, 0, 1, false)
		if #lines > 0 then search_line = lines[1] end
	end

	local lines = {search_line}
	local count = show_conf.height - 1
	for i = 0, count - 1 do
		local index = i + first_index
		if index > #show_vec then break end
		local data_index = show_vec[index]
		local item = data_vec[data_index]
		table.insert(lines, item:get_loc() .. ": " .. item:get_data())
	end

	vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
	--vim.schedule(function()
	--	vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
	--end)
	-- set hi
end

local function new(data, conf)
	data_vec = data
	set_conf(conf)
	set_show_vec()
	set_buf()
	open_win()
end

local function add(data)
	data_vec = vim.list_extend(data_vec, data)
end

local function move_next()
	local height = show_conf.height - 1
	local rows = vim.api.nvim_buf_line_count(buf_id) - 1

	if select_line < height and select_line < rows then
		select_line = select_line + 1
		refresh_sign()
		return ""
	end
	if rows < height then return "" end

	if #show_vec - first_index + 1 <= height then return "" end
	first_index = first_index + 1
	set_buf(true)
	return ""
end

local function move_pre()
	if select_line > 1 then
		select_line = select_line - 1
		refresh_sign()
		return ""
	end

	if first_index > 1 then
		first_index = first_index - 1
		set_buf(true)
		return ""
	end

	return ""
end

local function do_item()
	local i = first_index + select_line - 1
	local index = show_vec[i]
	close_win()
	local item = data_vec[index]
	item:do_item()
end

init_buf_once()
M.new = function(data, conf) new(data, conf) end
M.move_next = function() return move_next() end
M.move_pre = function() return move_pre() end
M.do_item = function() do_item() end
M.close = function() close_win() end
M.match = function() 
	set_show_vec(true)
	set_buf(true)
end

return M
