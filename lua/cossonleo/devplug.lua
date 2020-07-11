local M = {}

local on_attach = function(client)
	require('diagnostic').on_attach(client)
	require('lsp-status').on_attach(client)
end

M["'cespare/vim-toml', {'for': ['toml']}"] = function() end

M["'peterhoeg/vim-qml', {'for':['qml']}"] = function() end

M["'nvim-treesitter/nvim-treesitter'"] = function()
	require'nvim-treesitter.configs'.setup {
		highlight = { enable = true, disable = {} },
		incremental_selection = {
			enable = true,
			disable = {},
			keymaps = {                       -- mappings for incremental selection (visual mappings)
			  init_selection = 'gnn',         -- maps in normal mode to init the node/scope selection
			  node_incremental = "grn",       -- increment to the upper named parent
			  scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
			  node_decremental = "grm",      -- decrement to the previous node
			}
		},
		ensure_installed = 'all' -- one of 'all', 'language', or a list of languages
	}
end

M["'neovim/nvim-lsp'"] = function()
	require('vim.lsp.log').set_level(4)
	local lsp_status = require('lsp-status')
	local nvim_lsp = require('nvim_lsp')
	nvim_lsp.gopls.setup{
		on_attach=on_attach,
		settings = { gopls = { usePlaceholders = true,	completeUnimported = true } }
	}
	nvim_lsp.clangd.setup{callbacks = lsp_status.extensions.clangd.setup(),
		on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.pyls.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.dockerls.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.vimls.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.tsserver.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.bashls.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.rust_analyzer.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	-- nvim_lsp.sumneko_lua.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.intelephense.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.jsonls.setup{
		on_attach=on_attach,
		settings = { json = { format = { enable = true } } }, 
		capabilities = lsp_status.capabilities
	}
end

M["'jiangmiao/auto-pairs'"] = function()
end

M["'cossonleo/nvim-completor'"] = function()
end

M["'Shougo/echodoc.vim'"] = function()
	vim.g['echodoc#enable_at_startup'] = 1
	vim.g['echodoc#type'] = "floating"
end

M["'nvim-lua/diagnostic-nvim'"] = function()
	vim.g.diagnostic_insert_delay = 1
	vim.g.diagnostic_enable_virtual_text = 1
	vim.g.space_before_virtual_text = 5
	vim.g.space_before_virtual_text = 5
	vim.g.diagnostic_enable_underline = 0

	vim.api.nvim_set_keymap('n', ']e',  '<cmd>NextDiagnosticCycle<cr>', {silent = true, noremap = true})
	vim.api.nvim_set_keymap('n', '[e',  '<cmd>PrevDiagnosticCycle<cr>', {silent = true, noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>d',  '<cmd>OpenDiagnostic<cr>', {silent = true, noremap = true})
end

M["'nvim-lua/lsp-status.nvim'"] = function()
	local lsp_status = require('lsp-status')
	lsp_status.register_progress()
	lsp_status.config{
		indicator_errors = 'E',
		indicator_warnings = 'W',
		status_symbol = '',
	}
end

nvim_lsp_status = function()
	if #vim.lsp.buf_get_clients() > 0 then
		return require('lsp-status').status()
	end

	return ''
end

return M
