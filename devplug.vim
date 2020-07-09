if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

autocmd User PlugEndEvent call <SID>config()

autocmd User PlugAddEvent Plug 'cespare/vim-toml', {'for': ['toml']}
autocmd User PlugAddEvent Plug 'peterhoeg/vim-qml', {'for':['qml']}
autocmd User PlugAddEvent Plug 'nvim-treesitter/nvim-treesitter'
autocmd User PlugAddEvent Plug 'neovim/nvim-lsp'
autocmd User PlugAddEvent Plug 'jiangmiao/auto-pairs'
autocmd User PlugAddEvent Plug 'cossonleo/nvim-completor'
autocmd User PlugAddEvent Plug 'Shougo/echodoc.vim'
autocmd User PlugAddEvent Plug 'haorenW1025/diagnostic-nvim'

func s:config()
lua <<EOF
    require'nvim-treesitter.configs'.setup {
	highlight = {
	    enable = true,                    -- false will disable the whole extension
	    disable = {},        -- list of language that will be disabled
	},
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
	local nvim_lsp = require('nvim_lsp')
	local on_attach = function()
		require('diagnostic').on_attach()
	end
	nvim_lsp.rust_analyzer.setup{on_attach=on_attach}
	nvim_lsp.gopls.setup{
		on_attach=on_attach,
		settings = { gopls = {
				usePlaceholders = true,	
				completeUnimported = true,
			}
		}
	}
	nvim_lsp.clangd.setup{on_attach=on_attach}
	nvim_lsp.pyls.setup{on_attach=on_attach}
	nvim_lsp.dockerls.setup{on_attach=on_attach}
	nvim_lsp.vimls.setup{on_attach=on_attach}
	nvim_lsp.tsserver.setup{on_attach=on_attach}
	nvim_lsp.bashls.setup{on_attach=on_attach}
	nvim_lsp.rust_analyzer.setup{on_attach=on_attach}
	nvim_lsp.sumneko_lua.setup{on_attach=on_attach}
	nvim_lsp.intelephense.setup{on_attach=on_attach}
	nvim_lsp.jsonls.setup{
		on_attach=on_attach,
		settings = { json = { format = { enable = true } } }
	}
EOF


	inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

	let g:echodoc#enable_at_startup = 1
	let g:echodoc#type = "floating"

	let g:diagnostic_insert_delay = 1
	call sign_define("LspDiagnosticsErrorSign", {"text" : "E", "texthl" : "LspDiagnosticsError"})
	call sign_define("LspDiagnosticsWarningSign", {"text" : "W", "texthl" : "LspDiagnosticsWarning"})
	call sign_define("LspDiagnosticInformationSign", {"text" : "I", "texthl" : "LspDiagnosticsInformation"})
	call sign_define("LspDiagnosticHintSign", {"text" : "H", "texthl" : "LspDiagnosticsHint"})
	let g:diagnostic_enable_virtual_text = 1
	let g:space_before_virtual_text = 5
	let g:space_before_virtual_text = 5
	nnoremap <silent> ]e <cmd>NextDiagnosticCycle<cr>
	nnoremap <silent> [e <cmd>PrevDiagnosticCycle<cr>
	nnoremap <silent> <leader>d <cmd>OpenDiagnostic<cr>
endfunc
