""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: MIT
"     Author: cossonleo
"    Version: 0.5
" CreateTime: 2018-08-21 22:45:56
" LastUpdate: 2018-08-21 22:45:56
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""

if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

func lang_plug#add()
	Plug 'cespare/vim-toml', {'for': ['toml']}

	Plug 'rust-lang/rust.vim', {'for': ['rust']}
	Plug 'peterhoeg/vim-qml', {'for':['qml']}
	Plug 'mustache/vim-mustache-handlebars'

	Plug 'neoclide/coc.nvim', {'branch': 'release'}
endfunc

func lang_plug#config()
	"rust
	let g:cargo_makeprg_params = 'build'

	call coc_plug#coc_config()
endfunc
