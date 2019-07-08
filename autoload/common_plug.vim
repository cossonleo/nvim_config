""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: MIT
"     Author: Cosson2017
"    Version: 0..5
" CreateTime: 2018-08-21 22:02:23
" LastUpdate: 2018-08-21 22:02:23
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""

if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

func common_plug#add()
	Plug 'luochen1990/rainbow'
	Plug 'terryma/vim-multiple-cursors'
	Plug 'joshdick/onedark.vim'
	Plug 'haya14busa/incsearch.vim'
	Plug 'tpope/vim-surround'
	Plug 'kshenoy/vim-signature'
	Plug 'cossonleo/neo-comment.nvim'
	Plug 'cossonleo/neo-smooth-scroll.nvim'

	Plug 'cespare/vim-toml', {'for': ['toml']}
	Plug 'rust-lang/rust.vim', {'for': ['rust']}
	Plug 'peterhoeg/vim-qml', {'for':['qml']}
	Plug 'mustache/vim-mustache-handlebars'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
endfunc

func common_plug#config()

	"rust
	let g:cargo_makeprg_params = 'build'

	call coc_plug#coc_config()

	"NeoSolarized
	"let g:neosolarized_contrast = "normal"
	"let g:neosolarized_visibility = "normal"
	"let g:neosolarized_diffmode = "normal"
	"let g:neosolarized_bold = 1
	"let g:neosolarized_underline = 1
	"let g:neosolarized_italic = 0
	"let g:neosolarized_vertSplitBgTrans = 1
	"
	"let g:neosolarized_termtrans = 1
	"colorscheme NeoSolarized

	let g:onedark_color_overrides = {
				\ "black": {"gui": "#000000", "cterm": "235", "cterm16": 0}
				\ }
	colorscheme onedark
	
	" incsearch.vim
	map /  <Plug>(incsearch-forward)
	map ?  <Plug>(incsearch-backward)
	map g/ <Plug>(incsearch-stay)

	"rainbow
	let g:rainbow_active = 1
endfunc
