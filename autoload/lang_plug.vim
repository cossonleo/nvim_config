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
	"Plug 'prabirshrestha/vim-lsp'
	"Plug 'prabirshrestha/async.vim'
	"Plug 'majutsushi/tagbar'
	Plug 'cespare/vim-toml', {'for': ['toml']}
	Plug 'Shougo/echodoc.vim'
	Plug 'liuchengxu/vista.vim'
	"Plug 'Shougo/deoplete.nvim' 

	"""""""""""""""""""""
	"Plug 'roxma/nvim-yarp'
	"Plug 'ncm2/ncm2'
	"Plug 'ncm2/ncm2-bufword'
    "Plug 'ncm2/ncm2-path'
	"Plug 'ncm2/float-preview.nvim'
	"""""""""""""""""""""

	Plug 'rust-lang/rust.vim', {'for': ['rust']}
	Plug 'peterhoeg/vim-qml', {'for':['qml']}
	Plug 'mustache/vim-mustache-handlebars'
	" Track the engine.
	"Plug 'SirVer/ultisnips'

    "\ 'do': 'bash install.sh',
	Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
	\ 'do': 'make release',
    \ }

	"Plug 'prabirshrestha/async.vim'
	"Plug 'cossonleo/vim-lsp'
	"Plug 'cossonleo/denite-vim-lsp'
	
	Plug 'cossonleo/nvim-completor'
	Plug 'cossonleo/nvim-completor-lc'
	"Plug 'cossonleo/nvim-lsphi'
	"Plug 'cossonleo/nvim-completor-vim-lsp'
	"Plug 'andreshazard/vim-logreview'
	"Plug 'dzeban/vim-log-syntax'

	"c family highlight
	"call dein#add('arakashic/chromatica.nvim' ", {'for':['cpp', 'h', 'hpp', 'c']}
	"call dein#add('rhysd/vim-clang-format', {'for':['cpp', 'h', 'hpp', 'c']}

	"wx program
	"call dein#add('chemzqm/wxapp.vim')
	"tagbar 
	"call dein#add('cossonleo/neo-debuger')
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

	" deoplete.
	let g:deoplete#enable_at_startup = 1
	"call deoplete#custom#option('ignore_sources', {'_': ['buffer', 'around', 'member', 'omni', 'tag']})
	"
	" vim-lsp
	"call lsp_vim#vim_lsp_config()

	"vim-lc
	call lsp_lc#lsp_lc_config()

	"rust
	let g:cargo_makeprg_params = 'build'

	"""ncm2
	"autocmd BufEnter * call ncm2#enable_for_buffer()
	"set completeopt=noinsert,menuone,noselect
	"set shortmess+=c
	"inoremap <c-c> <ESC>
	"inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
	"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    "inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	"let g:ncm2#matcher = 'substrfuzzy'

	" float-preview.nvim
	"set completeopt+=preview
	
"	"nnoremap <silent> <m-j> :LspNextError<CR>
"	"nnoremap <silent> <m-k> :LspPreviousError<CR>
	

	" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<c-k>"
"let g:UltiSnipsJumpForwardTrigger="<c-k>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
endfunc
