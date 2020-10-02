
local M = {}

M["'luochen1990/rainbow'"] = function()
	vim.g.rainbow_active = 1
end

--M["'overcache/NeoSolarized'"] = function()
--	vim.api.nvim_command("colorscheme NeoSolarized")
--end

M["'joshdick/onedark.vim'"] = function()
	vim.g.onedark_color_overrides = {black = {gui = "#000000", cterm = "235", cterm16 = 0}}
	vim.api.nvim_command("colorscheme onedark")
end

-- M["'machakann/vim-sandwich'"] = function() end
M["'tpope/vim-surround'"] = function() end

M["'kshenoy/vim-signature'"] = function() end

M["'voldikss/vim-floaterm'"] = function()
	vim.g.floaterm_winblend = 10
	vim.g.floaterm_width = 0.7
	vim.g.floaterm_height = 0.8
	vim.g.floaterm_position = 'center'
	vim.g.floaterm_keymap_toggle = '<F4>'
	vim.g.floaterm_keymap_new    = '<leader><F4>'
	vim.g.floaterm_keymap_next   = '<F16>'
	vim.g.floaterm_border_color = "#FFFFFF"
end

M["'norcalli/nvim-colorizer.lua'"] = function() require 'colorizer'.setup(nil, { css = true; }) end

M["'terryma/vim-multiple-cursors'"] = function() end

M["'whiteinge/diffconflicts'"] = function() end

M["'cossonleo/dirdiff.nvim'"] = function() end

M["'cossonleo/neo-comment.nvim'"] = function() end

-- M["'cossonleo/neo-smooth-scroll.nvim'"] = function() end
M["'psliwka/vim-smoothie'"] = function() end

M["'easymotion/vim-easymotion'"] = function() 
	-- vim.api.nvim_set_keymap('n', 's', '<Plug>(easymotion-prefix)', {noremap = true, silent = true})
	-- vim.api.nvim_set_keymap('n', 's', '<Plug>(easymotion-s)', {noremap = true, silent = true})
	-- vim.api.nvim_exec("nnoremap s <Plug>(easymotion-s)", "")

	vim.g.EasyMotion_do_mapping = 0
	-- vim.api.nvim_set_keymap('n', 's', ':call EasyMotion#S(1, 0, 2)<cr>', {noremap = true, silent = true})
	vim.api.nvim_set_keymap('n', '/', ':call EasyMotion#S(-1, 0, 2)<cr>', {noremap = true, silent = true})
	-- vim.g.EasyMotion_leader_key = "s"
end

M["'voldikss/vim-translator'"] = function()
	vim.g.EasyMotion_do_mapping = 0
	vim.api.nvim_set_keymap('n', '<leader>a', ':TranslateW<CR>', {noremap = true, silent = true})
end

return M
