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
	Plug 'joshdick/onedark.vim'
	Plug 'machakann/vim-sandwich'
	Plug 'kshenoy/vim-signature'

	Plug 'cespare/vim-toml', {'for': ['toml']}
	Plug 'rust-lang/rust.vim', {'for': ['rust']}
	Plug 'peterhoeg/vim-qml', {'for':['qml']}
	"Plug 'mustache/vim-mustache-handlebars'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}

	"Plug 'tpope/vim-fugitive'
	Plug 'whiteinge/diffconflicts'
	Plug 'cossonleo/dirdiff.nvim'
	Plug 'cossonleo/neo-comment.nvim'
	Plug 'cossonleo/neo-smooth-scroll.nvim'

	Plug 'haya14busa/incsearch.vim'
	Plug 'haya14busa/incsearch-easymotion.vim'
	"Plug 'haya14busa/incsearch-fuzzy.vim'
	Plug 'easymotion/vim-easymotion'

endfunc

" You can use other keymappings like <C-l> instead of <CR> if you want to
" use these mappings as default search and sometimes want to move cursor with
" EasyMotion.
function! s:incsearch_config(...) abort
  return incsearch#util#deepextend(deepcopy({
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {
  \     "\<tab>": '<Over>(easymotion)'
  \   },
  \   'is_expr': 0
  \ }), get(a:, 1, {}))
endfunction

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
	noremap <silent><expr> /  incsearch#go(<SID>incsearch_config())
	noremap <silent><expr> ?  incsearch#go(<SID>incsearch_config({'command': '?'}))
	noremap <silent><expr> g/ incsearch#go(<SID>incsearch_config({'is_stay': 1}))

	let g:EasyMotion_do_mapping = 0

	"rainbow
	let g:rainbow_active = 1
endfunc
