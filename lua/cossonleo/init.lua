vim.o.hidden = true
vim.o.confirm = true
vim.o.termguicolors = true
--vim.o.tabstop = 4
--vim.o.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
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

vim.api.nvim_set_keymap("n", "<leader>g", ":lua require('cossonleo.delay').grep_dir()<cr>", {noremap = true})

vim.api.nvim_set_keymap("n", "]d", ":lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "[d", ":lua vim.lsp.buf.implementation()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>r", ":lua vim.lsp.buf.references()", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "gc", ":lua vim.lsp.buf.rename()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "gq", ":lua vim.lsp.buf.formatting()<cr>", {noremap = true, silent = true})
-- vim.api.nvim_set_keymap("n", "<c-k>", ":lua vim.lsp.buf.signature_help()<CR>", {noremap = true, silent = true})

