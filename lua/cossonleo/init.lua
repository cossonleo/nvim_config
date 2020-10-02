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
vim.o.termguicolors = true
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

vim.api.nvim_set_keymap("t", "<esc>", "<c-\\><c-N>", {noremap = true})
vim.api.nvim_set_keymap("t", "<c-w><c-w>", "<c-\\><c-N><c-w><c-w>", {noremap = true})
vim.api.nvim_set_keymap("t", "<c-w>h", "<c-\\><c-N><c-w>h", {noremap = true})
vim.api.nvim_set_keymap("t", "<c-w>j", "<c-\\><c-N><c-w>j", {noremap = true})
vim.api.nvim_set_keymap("t", "<c-w>k", "<c-\\><c-N><c-w>k", {noremap = true})
vim.api.nvim_set_keymap("t", "<c-w>l", "<c-\\><c-N><c-w>l", {noremap = true})


vim.api.nvim_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "gD", ":lua vim.lsp.buf.implementation()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "gc", ":lua vim.lsp.buf.rename()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "gk", ":lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "gq", ":lua vim.lsp.buf.formatting()<cr>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<c-k>", ":lua vim.lsp.buf.signature_help()<CR>", {noremap = true, silent = true})


vim.api.nvim_set_keymap('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "<Tab>"]], {noremap = true, expr = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], {noremap = true, expr = true})

cossonleo_plug_add = function()
	local add = require'cossonleo.delay'.add
	add(require'cossonleo.navplug')
	add(require'cossonleo.devplug')
	add(require'cossonleo.baseplug')
end

cossonleo_plug_config = function()
	local config = require'cossonleo.delay'.config
	config(require'cossonleo.navplug')
	config(require'cossonleo.devplug')
	config(require'cossonleo.baseplug')
end

vim.api.nvim_exec([[
autocmd User PlugAddEvent lua cossonleo_plug_add()
autocmd User PlugEndEvent lua cossonleo_plug_config()
autocmd UIEnter * lua vim.g.lua_tree_auto_open = 1
]], nil)
