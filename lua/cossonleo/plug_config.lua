local M = {}

function M.onedark()
	vim.g.onedark_color_overrides = {black = {gui = "#000000", cterm = "235", cterm16 = 0}}
	pcall(vim.cmd, [[ colorscheme onedark ]])
end

function M.solarized()
	vim.o.background = 'light'
	pcall(vim.cmd, [[ colorscheme NeoSolarized ]])
end

function M.vim_floaterm()
	vim.g.floaterm_winblend = 10
	vim.g.floaterm_width = 0.7
	vim.g.floaterm_height = 0.8
	vim.g.floaterm_position = 'center'
	vim.g.floaterm_keymap_toggle = '<F4>'
	vim.g.floaterm_keymap_new    = '<leader><F4>'
	vim.g.floaterm_keymap_next   = '<F16>'
	vim.g.floaterm_border_color = "#FFFFFF"
end

function M.nvim_colorizer()
	local has, c = pcall(require, 'colorizer')
	if not has then return end
	c.setup(nil, { css = true; })
end

function M.vim_translator()
	vim.g.EasyMotion_do_mapping = 0
	vim.cmd[[nnoremap <silent> <leader>a :TranslateW<CR>]]
end

function M.nvim_treesitter()
	local has, ts = pcall(require, 'nvim-treesitter.configs')
	if not has then return end

	require'ts_ext'.open_complete()
	ts.setup {
		ensure_installed = 'all', -- one of 'all', 'language', or a list of languages
		highlight = { 
			enable = true, 
			--disable = {'python', 'rust'} 
		},
		incremental_selection = {
			enable = true,
			disable = {},
			keymaps = {                       -- mappings for incremental selection (visual mappings)
			  init_selection = 'gn',         -- maps in normal mode to init the node/scope selection
			  node_incremental = "gn",       -- increment to the upper named parent
			  scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
			  node_decremental = "grm",      -- decrement to the previous node
			}
		},
		--rainbow	= {
		--	enable	= true,
		--	disable	= {'lua'},	--please	disable	lua	for	now
		--},
	}
end

function M.nvim_lsp()
	require("lsp_ext")
end

function M.diagnostic_nvim()
	vim.g.diagnostic_insert_delay = 1
	vim.g.diagnostic_enable_virtual_text = 1
	vim.g.space_before_virtual_text = 5
	vim.g.space_before_virtual_text = 5
	vim.g.diagnostic_enable_underline = 0

	vim.cmd[[nnoremap <silent> ]e <cmd>NextDiagnosticCycle<cr>]]
	vim.cmd[[nnoremap <silent> [e <cmd>PrevDiagnosticCycle<cr>]]
	vim.cmd[[nnoremap <silent> <leader>d <cmd>OpenDiagnostic<cr>]]
end

function M.nerdtree()
	vim.cmd[[nnoremap <leader>e :NERDTreeToggle<cr>]]
	vim.cmd[[autocmd VimEnter * lua open_nerdtree_on_enter()]]

	function open_nerdtree_on_enter()
		local argc = vim.fn.argc()
		if argc > 1 then
			return
		end

		if argc == 0 then
			vim.cmd[[NERDTreeToggle]]
			return
		end

		local argv = vim.fn.argv()[1]
		if vim.fn.isdirectory(argv) == 1 then
			vim.cmd[[enew]]
			vim.cmd("NERDTree " .. argv)
			vim.cmd("cd " .. argv)
		end
	end
end

return M
