local M = {}

function M.vim_easymotion()
	vim.g.EasyMotion_do_mapping = 0
	vim.cmd[[nnoremap <silent> / :call EasyMotion#S(-1, 0, 2)<cr>]]
end

function M.onedark()
	vim.g.onedark_color_overrides = {black = {gui = "#000000", cterm = "235", cterm16 = 0}}
	pcall(vim.cmd, [[ colorscheme onedark ]])
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
	require('vim.lsp.log').set_level(4)
	--local has, nvim_lsp = pcall(require, 'lspconfig')
	--if not has then return end
	local nvim_lsp = require'lspconfig'

	local ext = require'lsp_ext'
	local add = function(ls, opt)
		local config = opt or {}
		config.on_attach = config.on_attach or ext.default_config.on_attach
		config.capabilities = config.capabilities or ext.default_config.capabilities
		nvim_lsp[ls].setup(config)
	end

	add('gopls', {settings = { gopls = { usePlaceholders = true,	completeUnimported = true } }})
	add('clangd')
	add('pyls')
	add('dockerls')
	--add('vimls')
	add('tsserver')
	add('bashls')
	add('rust_analyzer', {settiings = { ["rust-analyzer"] = {} }})
	add('intelephense')
	add('jsonls', {
		settings = { json = { format = { enable = true } } }, 
	})
	--
	--add('sumneko_lua')
	--nvim_lsp.clangd.setup{callbacks = lsp_status.extensions.clangd.setup(),
end

function M.echodoc()
	vim.g['echodoc#enable_at_startup'] = 1
	vim.g['echodoc#type'] = "floating"
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

function M.lsp_status()
	local has, lsp_status = pcall(require, 'lsp-status')
	if not has then return end
	lsp_status.register_progress()
	lsp_status.config{
		indicator_errors = 'E',
		indicator_warnings = 'W',
		status_symbol = '',
	}
end

return M
