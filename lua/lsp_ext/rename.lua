local buf = 0
local win = 0

local function init_rename_buf()
	buf = vim.api.nvim_create_buf(false, true)
	vim.fn.sign_define("lsp_rename_sign", {text = "≡", texthl = "Normal", linehl = "Normal"})
	vim.fn.sign_place(0, "", "lsp_rename_sign", buf, {lnum = 1})

	local opts = {silent = true}
	local function inoremap(lhs, rhs) vim.api.nvim_buf_set_keymap(buf, "i", lhs, rhs, opts) end

	inoremap("<cr>", "<c-o><cmd>lua on_lsp_rename_request()<cr>")
	inoremap("<esc>", "<c-o><cmd>lua on_lsp_rename_close_win()<cr>")
	inoremap("<c-[>", "<c-o><cmd>lua on_lsp_rename_close_win()<cr>")
	inoremap("<c-o>", "<c-o><cmd>lua on_lsp_rename_close_win()<cr>")
end

function on_lsp_rename_close_win()
	if win > 0 then
		vim.api.nvim_win_close(win, true)
		win = 0
	end
	vim.cmd "stopinsert"
end

function on_lsp_rename_request()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
	local word = lines[1]
	on_lsp_rename_close_win()
	vim.lsp.buf.rename(word)
end

function lsp_rename()
	if vim.o.lines - vim.o.cmdheight < 3 then
		vim.lsp.buf.rename() 
		return
	end
	local cur_word = vim.fn.expand('<cword>')
	local width = #cur_word > 35 and #cur_word + 5 or 40
	if buf == 0 then init_rename_buf() end
	win = require'floatwin'.new_cursor_win(40, 1, {buf = buf})
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {cur_word})
	vim.api.nvim_win_set_cursor(win, {1, #cur_word})
	if vim.api.nvim_get_mode().mode ~= "i" then
		vim.cmd "startinsert!"
	end
end

return {
	request = lsp_rename, 
}
