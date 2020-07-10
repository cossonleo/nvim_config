vim.api.nvim_exec([[
	autocmd User PlugAddEvent lua require'devplug'.add()
	autocmd User PlugEndEvent lua require'devplug'.config()
]], nil)

M = {}

M.add = function()
	vim.api.nvim_exec([[
		Plug 'cespare/vim-toml', {'for': ['toml']}
		Plug 'peterhoeg/vim-qml', {'for':['qml']}
		Plug 'nvim-treesitter/nvim-treesitter'
		Plug 'neovim/nvim-lsp'
		Plug 'jiangmiao/auto-pairs'
		Plug 'cossonleo/nvim-completor'
		Plug 'Shougo/echodoc.vim'
		Plug 'nvim-lua/diagnostic-nvim'
		Plug 'nvim-lua/lsp-status.nvim'
	]], nil)
end

M.config = function()
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

	require('vim.lsp.log').set_level(4)
	local lsp_status = require('lsp-status')
	lsp_status.register_progress()
	lsp_status.config{
		indicator_errors = 'E',
		indicator_warnings = 'W',
		status_symbol = '',
	}

	local nvim_lsp = require('nvim_lsp')

	local on_attach = function(client)
		require('diagnostic').on_attach(client)
		lsp_status.on_attach(client)
	end

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

	vim.g['echodoc#enable_at_startup'] = 1
	vim.g['echodoc#type'] = "floating"

	vim.g.diagnostic_insert_delay = 1
	vim.g.diagnostic_enable_virtual_text = 1
	vim.g.space_before_virtual_text = 5
	vim.g.space_before_virtual_text = 5
	vim.g.diagnostic_enable_underline = 0

	nvim_lsp_status = function()
		if #vim.lsp.buf_get_clients() > 0 then
			return lsp_status.status()
		end

		return ''
	end

	vim.api.nvim_set_keymap('n', ']e',  '<cmd>NextDiagnosticCycle<cr>', {silent = true, noremap = true})
	vim.api.nvim_set_keymap('n', '[e',  '<cmd>PrevDiagnosticCycle<cr>', {silent = true, noremap = true})
	vim.api.nvim_set_keymap('n', '<leader>d',  '<cmd>OpenDiagnostic<cr>', {silent = true, noremap = true})
end

return M
