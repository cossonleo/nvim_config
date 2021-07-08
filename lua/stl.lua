
function stl_ts()
	return require(util).ts_stl()
end

function stl_file_size()
	vim.b.cur_fsize = nvim.get_cur_file_size()
end

function stl_lsp_info()
	return require("lsp_ext").statusline()
end

local function set(...)
	local args = { ... }
	local sep = [[ %#StatusLine#]]
	local stl = table.concat(args, sep)
	vim.o.stl = "%#StatusLine#" .. stl
end

set(
	[[%y]],
	[[%{luaeval('require"ts_ext".statusline()')}]],
	[[%m%r%h%w%q]],
	[[%=]],
	[[%{v:lua.stl_lsp_info()}]],
	[[line:%l/%L col:%c]],
	[[%{(&fenc!=''?&fenc:&enc)}]],
	[[%{(&bomb?",BOM":"")}]]
)

vim.cmd[[au FileType netrw,LuaTree setl stl=%*\ line:%l/%L]]
--vim.cmd[[au BufWritePost,BufReadPost * lua stl_file_name(50)]]
vim.cmd[[au BufWritePost,BufReadPost * lua stl_file_size(50)]]

vim.o.tabline = " t:%{tabpagenr()} b:%{bufnr()}%=%{expand('%:p')}%=%{get(b:,'cur_fsize','')} "
