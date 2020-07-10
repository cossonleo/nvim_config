
vim.api.nvim_exec([[
	autocmd User PlugAddEvent lua require'baseplug'.add()
	autocmd User PlugEndEvent lua require'baseplug'.config()
	autocmd User Startified setlocal buflisted
]], nil)

M = {}
M.add = function()
	vim.api.nvim_exec([[
		Plug 'luochen1990/rainbow'
		Plug 'joshdick/onedark.vim'
		Plug 'machakann/vim-sandwich'
		Plug 'kshenoy/vim-signature'
		Plug 'voldikss/vim-floaterm'
		Plug 'terryma/vim-multiple-cursors'
		Plug 'whiteinge/diffconflicts'
		Plug 'cossonleo/dirdiff.nvim'
		Plug 'cossonleo/neo-comment.nvim'
		Plug 'cossonleo/neo-smooth-scroll.nvim'
		Plug 'voldikss/vim-translator'
	]], nil)
end

M.config = function()
	vim.g.onedark_color_overrides = {black = {gui = "#000000", cterm = "235", cterm16 = 0}}
	vim.api.nvim_command("colorscheme onedark")
	
	vim.g.EasyMotion_do_mapping = 0

	-- rainbow
	vim.g.rainbow_active = 1

	-- vim-floaterm
	vim.g.floaterm_winblend = 10
	vim.g.floaterm_width = 0.7
	vim.g.floaterm_height = 0.8
	vim.g.floaterm_position = 'center'
	vim.g.floaterm_keymap_toggle = '<F4>'
	vim.g.floaterm_keymap_new    = '<leader><F4>'
	vim.g.floaterm_keymap_next   = '<F16>'
	vim.g.floaterm_border_color = "#FFFFFF"

	-- translator
	vim.api.nvim_set_keymap('n', '<leader>a', ':TranslateW<CR>', {noremap = true, silent = true})
end

return M
