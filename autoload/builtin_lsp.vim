""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: 
"     Author: 
"    Version: 
" CreateTime: 2020-01-15 18:15:54
" LastUpdate: 2020-01-15 18:15:54
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""

if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1


func! builtin_lsp#add()
	Plug 'neovim/nvim-lsp'
	Plug 'jiangmiao/auto-pairs'
	Plug 'cossonleo/nvim-completor'
endf

func builtin_lsp#config()
lua << EOF
	local nvim_lsp = require('nvim_lsp')
	nvim_lsp.rust_analyzer.setup{}	
	nvim_lsp.gopls.setup{}
	nvim_lsp.clangd.setup{}
	nvim_lsp.pyls.setup{}
	nvim_lsp.dockerls.setup{}
	nvim_lsp.vimls.setup{}
	nvim_lsp.tsserver.setup{}
	nvim_lsp.bashls.setup{}
	nvim_lsp.rust_analyzer.setup{}	
	nvim_lsp.sumneko_lua.setup{}
EOF

	autocmd Filetype rust,go,c,cpp,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc

	nnoremap <silent> gd 	<cmd>lua vim.lsp.buf.definition()<CR>
	nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
	nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
	nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
	nnoremap <silent> gc    <cmd>lua vim.lsp.buf.rename()<CR>
	nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
	nnoremap <silent> gq 	<cmd>lua vim.lsp.buf.formatting()<cr>
	"nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>

	inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "<Tab>"
endfunc
