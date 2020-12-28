local filter = require("share_sugar").fuzzy_match

local data_vec = {}
local show_vec = {}

-- 1-based
local first_index = 0
local select_line = 0
local last_match_pattern = ""

local buf_id = 0
local win_id = 0
local show_conf = {}

local search_sign_id = 0
local search_sign_id2 = 0
local select_sign_id = 0

vim.fn.sign_define("easy_search_sign_search", {text = ">>", texthl = "Error", linehl = "CursorLine"})
vim.fn.sign_define("easy_search_sign_search2", {text = ">", texthl = "Error", linehl = "CursorLine"})
vim.fn.sign_define("easy_search_sign_select", {text = "->", texthl = "Function", linehl = "CursorLine"})

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
	select_sign_id = vim.fn.sign_place(0, "", "easy_search_sign_select", buf_id, {lnum = select_line + 1})
end

local function search_sign()
	if search_sign_id > 0 then 
		vim.fn.sign_unplace("", {buffer = buf_id, id = search_sign_id})
	end
	search_sign_id = vim.fn.sign_place(0, "", "easy_search_sign_search", buf_id, {lnum = 1})

	if search_sign_id2 > 0 then 
		vim.fn.sign_unplace("", {buffer = buf_id, id = search_sign_id2})
	end
	search_sign_id2 = vim.fn.sign_place(0, "", "easy_search_sign_search2", buf_id, {lnum = 1})
end


local function open_win()
	if #data_vec == 0 then return end
	close_win()
	win_id = vim.api.nvim_open_win(buf_id, true, { 
		relative = "editor",
		row = show_conf.row,
		col = show_conf.col,
		width = show_conf.width,
		height = show_conf.height,
	})
	vim.api.nvim_win_set_cursor(win_id, {1, #last_match_pattern})
	vim.api.nvim_win_set_option(win_id, "number", false)
	vim.api.nvim_win_set_option(win_id, "relativenumber", false)
	vim.api.nvim_win_set_option(win_id, "signcolumn", "auto:3")
	vim.api.nvim_win_set_option(win_id, "wrap", false)
	refresh_sign()

--	vim.api.nvim_feedkeys("a", "n", true)
--startinsert
--stopinsert
	vim.cmd[[startinsert!]]
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

local function set_show_vec()
	show_vec = {}
	for i, item in ipairs(data_vec) do
		if last_match_pattern == "" then
			table.insert(show_vec, {i = i})
			goto continue
		end
		local match_info = filter(item:searched_str(), last_match_pattern)
		if not match_info  then
			goto continue
		end

		table.insert(show_vec, {i = i, match_info = match_info})
		::continue::
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
end

local function set_buf()
	local lines = {last_match_pattern}
	local count = show_conf.height - 1
	for i = 0, count - 1 do
		local index = i + first_index
		if index > #show_vec then break end
		local data_index = show_vec[index].i
		local item = data_vec[data_index]
		table.insert(lines, item:tips() .. item:searched_str())
	end

	vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
end

local function new(data, conf)
	data_vec = data
	last_match_pattern = ""
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
		return
	end
	if rows < height then return end

	if #show_vec - first_index + 1 <= height then return end
	first_index = first_index + 1
	set_buf()
end

local function move_pre()
	if select_line > 1 then
		select_line = select_line - 1
		refresh_sign()
		return
	end

	if first_index > 1 then
		first_index = first_index - 1
		set_buf()
		return
	end
end

local function do_item()
	local i = first_index + select_line - 1
	local index = show_vec[i].i
	local close, do_action = data_vec[index]:do_item()
	if close then close_win() end
	vim.schedule(do_action)
end

local function re_open()
	open_win()
end

local function search_item()
	local pattern = vim.fn.getline(1)
	if pattern == last_match_pattern then return end
	last_match_pattern = pattern
	set_show_vec()
	set_buf()
	refresh_sign()
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
	local do_cmd = ":lua require'easy_search/ui'.do_item()<cr>"
	local close = ":lua require'easy_search/ui'.close()<cr>"
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<cr>", "<c-[>" .. do_cmd, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<esc>", "<c-[>" .. close, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "n", "<esc>", close, opts)

	local next_cmd = [[<c-r>=luaeval("require'easy_search/ui'.move_next()")<CR>]]
	local pre_cmd = [[<c-r>=luaeval("require'easy_search/ui'.move_pre()")<CR>]]
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<c-j>", next_cmd, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<c-k>", pre_cmd, opts)
	search_sign()

	--vim.cmd("au TextChangedI <buffer="
	--	.. buf_id .. "> lua require'easy_search/ui'.match()")

	vim.api.nvim_buf_attach(buf_id, false, {
		on_lines = function(...)
			local args = { ... }
			if args[4] > 0 then return end
			--print(vim.fn.string(args))
			vim.schedule(function() search_item() end)
		end
	})
end

init_buf_once()
return {
	new = function(data, conf) new(data, conf) end,
	move_next = function() 
		vim.schedule(function() move_next() end)
		return ""
	end,

	move_pre = function() 
		vim.schedule(function() move_pre() end)
		return ""
	end,

	do_item = function() do_item() end,
	close = function() close_win() end,
	re_open = function() re_open() end,
	match = function() search_item() end,
}
