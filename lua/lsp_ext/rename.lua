local buf = 0
local win = 0

local function init_rename_buf()
	buf = vim.api.nvim_create_buf(false, true)
	vim.fn.sign_define("lsp_rename_sign", {text = "≡", texthl = "Normal", linehl = "Normal"})
	vim.fn.sign_place(0, "", "lsp_rename_sign", buf, {lnum = 1})

	local opts = {silent = true}
	local function inoremap(lhs, rhs) vim.api.nvim_buf_set_keymap(buf, "i", lhs, rhs, opts) end

	inoremap("<cr>", "<c-o><cmd>lua nvim.lsp.rename_request()<cr>")
	inoremap("<esc>", "<c-o><cmd>lua nvim.lsp.close_rename_win()<cr>")
	inoremap("<c-[>", "<c-o><cmd>lua nvim.lsp.close_rename_win()<cr>")
	inoremap("<c-o>", "<c-o><cmd>lua nvim.lsp.close_rename_win()<cr>")
end

nvim.lsp.close_rename_win = function()
	if win > 0 then
		vim.api.nvim_win_close(win, true)
		win = 0
	end
	vim.cmd "stopinsert"
end

nvim.lsp.rename_request = function()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
	local word = lines[1]
	nvim.lsp.close_rename_win()
	vim.lsp.buf.rename(word)
end

nvim.lsp.rename = function()
	if vim.o.lines - vim.o.cmdheight < 3 then
		vim.lsp.buf.rename() 
		return
	end
	local cur_word = vim.fn.expand('<cword>')
	local width = #cur_word > 35 and #cur_word + 5 or 40
	if buf == 0 then init_rename_buf() end
	win = nvim.new_win_by_cursor(40, 1, {buf = buf})
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {cur_word})
	vim.api.nvim_win_set_cursor(win, {1, #cur_word})
	if vim.api.nvim_get_mode().mode ~= "i" then
		vim.cmd "startinsert!"
	end
end
