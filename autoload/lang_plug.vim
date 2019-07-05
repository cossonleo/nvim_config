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
	"Plug 'Shougo/echodoc.vim'
	"Plug 'liuchengxu/vista.vim'

	Plug 'rust-lang/rust.vim', {'for': ['rust']}
	Plug 'peterhoeg/vim-qml', {'for':['qml']}
	Plug 'mustache/vim-mustache-handlebars'
	" Track the engine.
	"Plug 'SirVer/ultisnips'


	Plug 'neoclide/coc.nvim', {'branch': 'release'}

    ""\ 'do': 'bash install.sh',
	"Plug 'autozimu/LanguageClient-neovim', {
    "\ 'branch': 'next',
	"\ 'do': 'make release',
    "\ }

	""Plug 'prabirshrestha/async.vim'
	""Plug 'cossonleo/vim-lsp'
	""Plug 'cossonleo/denite-vim-lsp'
	"
	"Plug 'cossonleo/nvim-completor'
	"Plug 'cossonleo/nvim-completor-lc'
	""Plug 'cossonleo/nvim-lsphi'
	""Plug 'cossonleo/nvim-completor-vim-lsp'
	""Plug 'andreshazard/vim-logreview'
	""Plug 'dzeban/vim-log-syntax'

	""c family highlight
	""call dein#add('arakashic/chromatica.nvim' ", {'for':['cpp', 'h', 'hpp', 'c']}
	""call dein#add('rhysd/vim-clang-format', {'for':['cpp', 'h', 'hpp', 'c']}

	""wx program
	""call dein#add('chemzqm/wxapp.vim')
	""tagbar 
	""call dein#add('cossonleo/neo-debuger')
endfunc

func lang_plug#config()
	"chromatica
	"au FileType h,hpp,c,cpp ChromaticaStart
	let g:chromatica#enable_at_startup = 0
	let g:chromatica#highlight_feature_level = 1
	let g:chromatica#responsive_mode=1
	let g:chromatica#delay_ms = 50
	let g:chromatica#libclang_path = '/usr/lib/libclang.so'

	"echodoc
	let g:echodoc_enable_at_startup = 1
	let g:echodoc#type = 'floating'
	"let g:echodoc#type = 'virtual'

	" deoplete.
	let g:deoplete#enable_at_startup = 1
	"call deoplete#custom#option('ignore_sources', {'_': ['buffer', 'around', 'member', 'omni', 'tag']})

	"rust
	let g:cargo_makeprg_params = 'build'
endfunc
