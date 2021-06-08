local util = 'nvim_eutil.util'

function stl_ts()
	return require(util).ts_stl()
end

function stl_file_size()
	vim.b.cur_fsize = nvim.util.cur_file_size()
end

function stl_lsp_info()
	return require("lsp_ext").statusline()
end

function stl_file_name(len)
	local len = len or 50
	vim.b.fit_len_fname = nvim.util.buf_path()
end

local function set(...)
	local args = { ... }
	local sep = [[ %#StatusLine#]]
	local stl = table.concat(args, sep)
	vim.o.stl = sep .. stl
end

set(
	[[%y]],
	[[%m%r%h%w%q]],
	[[%=]],
	[[%{v:lua.stl_lsp_info()}]],
	[[%{luaeval('require"ts_ext".statusline()')}]],
	[[(%l,%c)/%L]],
	[[%{(&fenc!=''?&fenc:&enc)}]],
	[[%{(&bomb?",BOM":"")}]]
)

vim.cmd[[au FileType netrw,LuaTree setl stl=%*\ line:%l/%L]]
--vim.cmd[[au BufWritePost,BufReadPost * lua stl_file_name(50)]]
vim.cmd[[au BufWritePost,BufReadPost * lua stl_file_size(50)]]

vim.o.tabline = " %{tabpagenr()}%=%{expand('%:p')}%=%{get(b:,'cur_fsize','')} "
