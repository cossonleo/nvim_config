if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

autocmd User PlugAddEvent call <SID>add()
autocmd User PlugEndEvent call <SID>config()

func s:add()
	Plug 'cespare/vim-toml', {'for': ['toml']}
	Plug 'peterhoeg/vim-qml', {'for':['qml']}
endfunc

func s:config()
	"rust
	let g:cargo_makeprg_params = 'build'

	"go
	let g:go_highlight_functions = 1
	let g:go_highlight_methods = 1
	let g:go_highlight_fields = 1
	let g:go_highlight_types = 1
	let g:go_highlight_operators = 1
	let g:go_highlight_build_constraints = 1
endfunc
