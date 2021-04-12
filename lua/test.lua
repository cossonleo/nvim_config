
local buf = vim.api.nvim_create_buf(false, true)
local win = vim.api.nvim_open_win(buf, true, {
	relative = 'cursor',
	height = 1,
	width = 20,
	row = 2,
	col = 2,
})

vim.cmd "startinsert"

local input = ""

local key_c_h = vim.fn.nr2char(8)
local key_bs = vim.fn.nr2char("\\<BS>")
local esc_key = vim.fn.nr2char(27)

--vim.api.nvim_exec([[
--function! GetChar()
--	let c = getchar()
--	if c == "\<BS>"
--		return 8
--	else
--		return c
--	endif
--endfunction
--]], {})

function loop()
	--print("----------")
	--local c = vim.fn.nr2char(vim.api.nvim_eval("GetChar()"))
	local c = vim.fn.nr2char(vim.fn.getchar())
	if key_c_h == c then
		input = input:sub(1, #input - 1)
	elseif key_bs == c then
		input = input:sub(1, #input - 1)
	elseif  c == esc_key then
		vim.api.nvim_win_close(win, true)
		return
	else
		input = input .. c
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {input})
	vim.defer_fn(loop, 0)
end

vim.schedule_wrap(loop)
--vim.defer_fn(loop, 10)
