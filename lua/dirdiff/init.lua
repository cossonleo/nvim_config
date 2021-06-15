
local float_buf = nil
local diff_win = nil
local plat = nil
local M = {}

M.diff = function(is_rec, ...)
	plat = plat or require('dirdiff/plat')
	float_buf = float_buf or require('dirdiff/float_buf')

	local ret = plat.parse_arg(...)
	if not ret.ret then
		print("dir err")
		return
	end
	float_buf:diff_dir(ret.mine, ret.others, is_rec)
end

M.show = function()
	if not float_buf then return end
	float_buf:show()
end
M.close = function()
	diff_win = diff_win or require('dirdiff/diff_win')
	diff_win:close_cur_tab()
end
M.close_all = function()
	diff_win = diff_win or require('dirdiff/diff_win')
	diff_win:close_all_tab()
end
M.diff_cur = function()
	if not float_buf then return end
	float_buf:diff_cur_line()
end
M.diff_next = function()
	if not float_buf then return end
	float_buf:diff_next_line()
end
M.diff_pre = function()
	if not float_buf then return end
	float_buf:diff_pre_line()
end
M.close_win = function()
	if not float_buf then return end
	float_buf:close_win()
end

function dirdiff_cmdcomplete(A, L, P)
	plat = plat or require('dirdiff/plat')
	return plat.cmdcomplete(A,L,P)
end

local function  def_diff_cmd(cmd_name, is_rec)
	is_rec = is_rec and "true" or "false"
	local cmd_str = string.format(
		"command -nargs=+  -complete=customlist,%s %s lua require'dirdiff'.diff(%s, <f-args>)",
		"v:lua.dirdiff_cmdcomplete",
		cmd_name,
		is_rec
	)
	vim.cmd(cmd_str)

end

local function def_common_cmd(cmd_name, func_name)
	local cmd_str = string.format(
		"command %s lua require'dirdiff'.%s()",
		cmd_name,
		func_name
	)
	vim.cmd(cmd_str)
end

def_diff_cmd("DDiff", false)
def_diff_cmd("DDiffRec", true)
def_common_cmd("DResume", "show")
def_common_cmd("DClose", "close")
def_common_cmd("DCloseAll", "close_all")
def_common_cmd("DNext", "diff_next")
def_common_cmd("DPre", "diff_pre")


vim.cmd "hi! link DirdiffChange Identifier"
vim.cmd "hi! link DirdiffAdd Statement"
vim.cmd "hi! link DirdiffDelete Error"

--hi DirDiffBack guifg=#61afef
--hi DirDiffChange guifg=#E5C07B
--hi DirDiffAdd guifg=#98C379
--hi DirDiffRemove guifg=#E06C75
return M

