if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

autocmd User PlugAddEvent call <SID>add()
autocmd User PlugEndEvent call <SID>config()

func s:add()
	Plug 'cespare/vim-toml', {'for': ['toml']}
	Plug 'peterhoeg/vim-qml', {'for':['qml']}
	Plug 'nvim-treesitter/nvim-treesitter'
endfunc

func s:config()
	"rust
	let g:cargo_makeprg_params = 'build'
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
EOF
endfunc
