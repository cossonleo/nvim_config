vim.o.hidden = true
vim.o.confirm = true
vim.o.termguicolors = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.bo.expandtab = false
vim.o.diffopt = "internal,filler,closeoff,vertical,algorithm:patience"
vim.o.showcmd = true
vim.o.cmdheight = 2
vim.o.laststatus = 2
vim.o.scrolloff = 0
vim.o.clipboard = 'unnamedplus'
vim.o.completeopt = 'menuone,noselect,noinsert'
vim.o.updatetime = 500
vim.o.selection = 'inclusive'
vim.o.hlsearch = false
vim.o.smartcase = true
vim.o.formatoptions = ""
vim.o.maxmempattern = 10000
vim.o.wildmenu = true
vim.o.wildmode = 'longest,full'
vim.o.fileencodings = 'utf-8,ucs-bom,gb2312,gbk,gb18030,latin1'
vim.o.mouse = 'nvic'
vim.o.mousemodel = 'popup'
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.cursorcolumn = false

vim.o.t_8f = "\\<Esc>[38;2;%lu;%lu;%lum"
vim.o.t_8b = "\\<Esc>[48;2;%lu;%lu;%lum"

vim.o.guifont="Source_Code_Pro:h20:w20"

vim.cmd[[tnoremap <esc> <c-\><c-N>]]
vim.cmd[[tnoremap <c-w><c-w> <c-\><c-N><c-w><c-w>]]
vim.cmd[[tnoremap <c-w>h <c-\><c-N><c-w>h]]
vim.cmd[[tnoremap <c-w>j <c-\><c-N><c-w>j]]
vim.cmd[[tnoremap <c-w>k <c-\><c-N><c-w>k]]
vim.cmd[[tnoremap <c-w>l <c-\><c-N><c-w>l]]

vim.cmd[[nnoremap <silent> 3<Leftmouse> <3-Leftmouse>]]
vim.cmd[[nnoremap <silent> 4<Leftmouse> <4-Leftmouse>]]
vim.cmd[[vnoremap <silent> <RightMouse> y]]
vim.cmd[[inoremap <silent> <RightMouse> <c-o>p]]

vim.api.nvim_exec([[
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END
]], {})

vim.cmd[[autocmd BufReadPost * lua goto_last_pos()]]
function goto_last_pos()
	local last_pos = vim.fn.line("'\"")
	if last_pos > 0 and last_pos <= vim.fn.line("$") then
		vim.api.nvim_win_set_cursor(0, {last_pos, 0})
	end
end

--if has('win32') || has('win64')
--	set guifont=:h20
--endif

--if &term =~# '^screen'
--    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
--    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
--endif

vim.g.netrw_liststyle = 3
vim.cmd[[nnoremap <silent> <leader>e :20Lexplore<cr>]]
vim.cmd[[autocmd VimEnter * lua open_netrw_on_enter()]]
function open_netrw_on_enter()
	local argc = vim.fn.argc()
	if argc > 1 then return end

	local cmds = {"20Lexplore", "wincmd p"}
	local argv = vim.fn.argv()[1]
	if argv then
		if vim.fn.isdirectory(argv) == 0 then return end
		cmds = {"enew", "cd " .. argv, "20Lexplore"}
	end

	for _, cmd in ipairs(cmds) do
		vim.cmd(cmd)
	end
end

--vim.g.neosolarized_diffmode = "high"

nvim_eutil = {}
require 'nvim_eutil'

require 'plugins'
require 'easy_search'
require 'quick_motion'
require 'stl'
require 'completor'
require 'ts_ext'
require 'dirdiff'
require 'float_term'

--vim.api.nvim_register_filterfunc(function(prefix, match)
--	print("prefix nil", prefix == nil)
--	--print("prefix", prefix)
--	if prefix == "" then
--		return 1
--	end
--	if match == "bcd" then
--		return 1
--	end
--	return 0
--end)
--
--function test_complete()
--	--vim.api.nvim_complete(1, {"abc", "bcd"}, {})
--	local c1 = vim.b.changedtick
--	vim.api.nvim_buf_set_lines(0, 0, 0, false, {"hhhhhhhhhhhhhhhhhhhhhhh"})
--	local c2 = vim.b.changedtick
--	vim.api.nvim_buf_set_text(0, 0, 0, 1, 1, {"ccccccccc"})
--	local c3 = vim.b.changedtick
--	print(c1, c2, c3)
--	return ""
--end
--
--vim.cmd[[inoremap <F5> <c-r>=v:lua.test_complete()<cr>]]
-- :au CursorHold <buffer=33>  echo 'hold'
