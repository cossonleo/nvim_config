local function win_set_option(win, opts)
	local wo = function(opt, value)
		vim.api.nvim_win_set_option(win, opt, value)
	end

	opts = opts or {}
	local relativenumber = opts.relativenumber or false
	local number = opts.number or false
	local winhl = opts.winhl or "NormalFloat"
	local wrap = opts.wrap or false
	local signcolumn = opts.signcolumn or "auto"

	wo("relativenumber", relativenumber)
	wo("number", number)
	wo("winhl", "Normal:" .. winhl)
	wo("wrap", wrap)
	wo("signcolumn", signcolumn)
end

-- 创建相对光标的float win
nvim.new_win_by_cursor = function(width, height, opts)
	local border = opts and opts.border or 'single'
	local focus = opts and opts.focus or true
	local buf = opts and opts.buf or vim.api.nvim_create_buf(false, true)

	local total_w = border == "none" and width or width + 2
	local total_h = border == "none" and height or height + 2

	--local lines = vim.o.lines - vim.o.cmdheight
	local columns = vim.o.columns
	local win_pos = vim.api.nvim_win_get_position(0)
	local win_line = vim.fn.winline() + win_pos[1] -- 1-based
	local win_col = vim.fn.wincol() + win_pos[2]

	local calc_row_col = function()
		if win_line + total_h <= vim.o.lines then
			return 1, -1
		end
		if win_line > total_h then
			row = -1 * total_h
			col = -1
			return -1 * total_h, -1
		end
		return -1 * (win_line - 1), 1
	end

	local row, col = calc_row_col()
	if total_w + win_col + col - 1  > columns then
		local temp = total_w + win_col - columns - 1
		if temp < win_col then
			col = -1 * temp
		else
			col = -1 * (win_col - 1)
		end
	end

	local win = vim.api.nvim_open_win(buf, focus, {
		relative = "cursor",
		row = row,
		col = col,
		height = height,
		width = width,
		border = border,
		zindex = 300,
	})

	win_set_option(win, opts)
	return win
end

-- 创建相对整个编辑器的float win
nvim.new_win_by_editor = function(width, height, opts)
	local border = opts and opts.border or 'single'
	local focus = opts and opts.focus or true
	local row = opts and opts.row or 0.5
	local col = opts and opts.col or 0.5
	local buf = opts and opts.buf or vim.api.nvim_create_buf(false, true)

	local v_cols = vim.o.columns
	local v_lines = vim.o.lines
	if border ~= "none" then
		v_cols = v_cols - 2 -- 预留两个给窗口装饰
		v_lines = v_lines - 2 -- 预留两个给窗口装饰
	end

	if width < 1 then
		width = math.ceil(v_cols * width)
	else
		width = math.min(width, v_cols)
	end

	if height < 1 then
		height = math.ceil(v_lines * height)
	else
		height = math.min(height, v_lines)
	end

	local w = border == "none" and width or width + 2
	if col < 1 then
		col = (vim.o.columns - w) * col
		col = math.floor(col)
	end

	local h = border == "none" and height or height + 2
	if row < 1 then
		row = (vim.o.lines - h) * row
		row = math.floor(row)
	end
	col = math.min(vim.o.columns - w, col)
	row = math.min(vim.o.lines - h, row)

	local win = vim.api.nvim_open_win(buf, focus, {
		relative = "editor",
		row = row,
		col = col,
		height = height, -- 不包括窗口装饰
		width = width, -- 不包括窗口装饰
		border = border,
		zindex = 300,
	})

	win_set_option(win, opts)
	return win
end
