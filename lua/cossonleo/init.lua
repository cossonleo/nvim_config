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
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.cursorcolumn = false

vim.cmd[[ tnoremap <esc> <c-\><c-N> ]]
vim.cmd[[ tnoremap <c-w><c-w> <c-\><c-N><c-w><c-w> ]]
vim.cmd[[ tnoremap <c-w>h <c-\><c-N><c-w>h ]]
vim.cmd[[ tnoremap <c-w>j <c-\><c-N><c-w>j ]]
vim.cmd[[ tnoremap <c-w>k <c-\><c-N><c-w>k ]]
vim.cmd[[ tnoremap <c-w>l <c-\><c-N><c-w>l ]]
vim.cmd[[ nnoremap gd :lua vim.lsp.buf.definition()<CR> ]]
vim.cmd[[ nnoremap gD :lua vim.lsp.buf.implementation()<CR> ]]
vim.cmd[[ nnoremap gc :lua vim.lsp.buf.rename()<CR ]]
vim.cmd[[ nnoremap gk :lua vim.lsp.buf.hover()<CR> ]]
vim.cmd[[ nnoremap gq :lua vim.lsp.buf.formatting()<cr> ]]
vim.cmd" nnoremap <silent> [m :lua  require'ts_ext'.goto_context_start()<cr>"
vim.cmd" nnoremap <silent> ]m :lua  require'ts_ext'.goto_context_end()<cr>"
vim.cmd[[ inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "<Tab>" ]]
vim.cmd[[ inoremap <expr> <S-Tab>  pumvisible() ? "\<C-p>" : "\<S-Tab>" ]]

require'cossonleo.plugins'

local M = {}

local function get_util()
	return require'cossonleo.util'
end

function M.ts_stl()
	return get_util().ts_stl()
end

function M.current_file_size()
	vim.b.cur_fsize = get_util().current_file_size()
end

function M.lsp_info()
	return get_util().lsp_info()
end

function M.file_name_limit(len)
	local len = len or 50
	vim.b.fit_len_fname = get_util().file_name_limit(len)
end

return M


--vim.api.nvim_set_keymap('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "<Tab>"]], {noremap = true, expr = true})
--vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], {noremap = true, expr = true})
--vim.api.nvim_set_keymap("t", "<esc>", "<c-\\><c-N>", {noremap = true})
--vim.api.nvim_set_keymap("t", "<c-w><c-w>", "<c-\\><c-N><c-w><c-w>", {noremap = true})
--vim.api.nvim_set_keymap("t", "<c-w>h", "<c-\\><c-N><c-w>h", {noremap = true})
--vim.api.nvim_set_keymap("t", "<c-w>j", "<c-\\><c-N><c-w>j", {noremap = true})
--vim.api.nvim_set_keymap("t", "<c-w>k", "<c-\\><c-N><c-w>k", {noremap = true})
--vim.api.nvim_set_keymap("t", "<c-w>l", "<c-\\><c-N><c-w>l", {noremap = true})
--vim.api.nvim_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})
--vim.api.nvim_set_keymap("n", "gD", ":lua vim.lsp.buf.implementation()<CR>", {noremap = true, silent = true})
--vim.api.nvim_set_keymap("n", "gc", ":lua vim.lsp.buf.rename()<CR>", {noremap = true, silent = true})
--vim.api.nvim_set_keymap("n", "gk", ":lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true})
--vim.api.nvim_set_keymap("n", "gq", ":lua vim.lsp.buf.formatting()<cr>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<c-k>", ":lua vim.lsp.buf.signature_help()<CR>", {noremap = true, silent = true})


