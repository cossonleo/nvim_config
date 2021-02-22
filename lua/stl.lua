local util = 'cossonleo.util'

function stl_ts()
	return require(util).ts_stl()
end

function stl_file_size()
	vim.b.cur_fsize = require(util).current_file_size()
end

function stl_lsp_info()
	return require("lsp_ext").statusline()
end

function stl_file_name(len)
	local len = len or 50
	vim.b.fit_len_fname = require(util).file_name_limit(len)
end

local function set(...)
	local args = { ... }
	local sep = [[ %#StatusLine#]]
	local stl = table.concat(args, sep)
	vim.o.stl = sep .. stl
end

set(
	[[%{get(b:,'cur_fsize','')}]],
	[[%{get(b:,'fit_len_fname','')}]],
	[[%m%r%h%w%q]],
	[[%=]],
	[[%{v:lua.stl_lsp_info()}]],
	[[%{luaeval('require"ts_ext".statusline()')}]],
	[[%y]],
	[[(%l,%c)/%L]],
	[[%{(&fenc!=''?&fenc:&enc)}]],
	[[%{(&bomb?",BOM":"")}]]
)

vim.cmd[[au FileType netrw,LuaTree setl stl=%*\ line:%l/%L]]
vim.cmd[[au BufWritePost,BufReadPost * lua stl_file_name(50)]]
vim.cmd[[au BufWritePost,BufReadPost * lua stl_file_size(50)]]
