
local buf = vim.api.nvim_create_buf(false, true)
local win = vim.api.nvim_open_win(buf, true, {
	relative = 'cursor',
	height = 1,
	width = 40,
	row = 1,
	col = 3,
	border = "single",
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

local loop = function (c)
	if win == 0 then
		return
	end
	--print("----------")
	--local c = vim.fn.nr2char(vim.api.nvim_eval("GetChar()"))
	--local c = vim.fn.nr2char(vim.fn.getchar())
	print("aaaaaaaaaaaaaaa")
	if key_c_h == c then
		input = input:sub(1, #input - 1)
		print("111111111111111111")
	elseif key_bs == c then
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"33333333333333333"})
		input = input:sub(1, #input - 1)
		print("222222222222222222")
	elseif  c == esc_key then
		vim.api.nvim_win_close(win, true)
		win = 0
		return
	end
	--vim.api.nvim_buf_set_lines(buf, 0, -1, false, {input})
	-- vim.schedule_wrap(loop)()
	--vim.defer_fn(loop, 0)
end
local ns_id = vim.api.nvim_create_namespace("tttttttttttttest")
vim.register_keystroke_callback(loop, ns_id)

local function Aaa()
	function ccc()

	end

end

function B:Aaa()

end

function Aaa()

end

function C.Aaa()

end


--vim.schedule_wrap(loop)()
--vim.defer_fn(loop, 0)
