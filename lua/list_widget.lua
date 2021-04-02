
vim.fn.sign_define("easy_search_sign_search", {text = "Ϙ ", texthl = "LineNr", linehl = "LineNr"})
vim.fn.sign_define("easy_search_sign_select", {text = "☞ ", texthl = "LineNr", linehl = "LineNr"})

local get_buf_id = nvim_eutil.call_once(function()
	local buf_id = vim.api.nvim_create_buf(false, true)
	if buf_id == 0 then
		vim.cmd[[echoerr "create buf false"]]
		return
	end

	vim.api.nvim_buf_set_option(buf_id, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf_id, "swapfile", false)

	local opts = {noremap = true, silent = true}
	local do_cmd = ":lua require'easy_search/ui'.do_item()<cr>"
	local close = ":lua require'easy_search/ui'.close()<cr>"
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<cr>", "<c-[>" .. do_cmd, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<esc>", "<c-[>" .. close, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "n", "<esc>", close, opts)

	vim.api.nvim_buf_set_keymap(
		buf_id,
		"i", 
		"<c-j>", 
		"<c-r>=v:lua.easy_search_move_next()<CR>", 
		opts
	)

	vim.api.nvim_buf_set_keymap(
		buf_id,
		"i",
		"<c-k>",
		"<c-r>=v:lua.easy_search_move_pre()<CR>", 
		opts
	)

	search_sign()

	vim.api.nvim_buf_attach(buf_id, false, {
		on_lines = function(...)
			local args = { ... }
			if args[4] > 0 then return end
			--print(vim.fn.string(args))
			vim.schedule(easy_search_fuzzy_search)
		end
	})

	return buf_id
end)

local view_data = {
	data = {},
	offset = 0, -- 0-based
	row_len = 0,
}

function view_data:new(data, row_len)
	local o = {
		data = data,
		offset = 0,
		row_len = row_len,
	}

	setmetatable(o, {__index = self})
	return o
end

function view_data:view()
	local rows = {}
	local len = self.row_len
	if #self.data < len then 
		len = #self.data 
	end 
	for i = 1, len do
		table.insert(rows, self.data[self.offset + i])
	end
	return rows
end

function view_data:scroll_down()
	if self.offset + self.row_len < #self.data then
		self.offset = self.offset + 1
		return true
	end
	return false
end

function view_data:scroll_up()
	if self.offset > 0 then
		self.offset = self.offset - 1
		return true
	end
	return false
end

local buf_state = {
	buf_id = 0,
	select = 0, -- 0-based
	search_sign = 0,
	select_sign = 0,
}

function buf_state:init()
	if self.buf_id > 0 then return end

	local buf_id = vim.api.nvim_create_buf(false, true)
	if buf_id == 0 then
		vim.cmd[[echoerr "create buf false"]]
		return
	end
	self.buf_id = buf_id

	vim.api.nvim_buf_set_option(buf_id, "buftype", "nofile")
	--vim.api.nvim_buf_set_option(buf_id, "bufhidden", "delete")
	vim.api.nvim_buf_set_option(buf_id, "swapfile", false)

	local opts = {noremap = true, silent = true}
	local do_cmd = ":lua require'easy_search/ui'.do_item()<cr>"
	local close = ":lua require'easy_search/ui'.close()<cr>"
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<cr>", "<c-[>" .. do_cmd, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "i", "<esc>", "<c-[>" .. close, opts)
	vim.api.nvim_buf_set_keymap(buf_id, "n", "<esc>", close, opts)

	vim.api.nvim_buf_set_keymap(
		buf_id,
		"i", 
		"<c-j>", 
		"<c-r>=v:lua.easy_search_move_next()<CR>", 
		opts
	)
	vim.api.nvim_buf_set_keymap(
		buf_id,
		"i",
		"<c-k>",
		"<c-r>=v:lua.easy_search_move_pre()<CR>", 
		opts
	)

	search_sign()

	vim.api.nvim_buf_attach(buf_id, false, {
		on_lines = function(...)
			local args = { ... }
			if args[4] > 0 then return end
			vim.schedule(easy_search_fuzzy_search)
		end
	})
end

function easy_search_fuzzy_search()
end

function easy_search_move_next()
end

function easy_search_move_pre()
end

function easy_search_close_win()
end

function easy_search_do_item()
end

local view = {
	buf_id = 0,
	data = {},
	first = 0,
	cur = 0,
}
