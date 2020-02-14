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
	Plug 'roxma/nvim-yarp'
	Plug 'ncm2/ncm2'
	Plug 'ncm2/ncm2-bufword'
	Plug 'ncm2/ncm2-path'
endf

func builtin_lsp#config()
lua << EOF
	local nvim_lsp = require('nvim_lsp')
	local ncm2 = require('ncm2')

	require'nvim_lsp'.rust_analyzer.setup{on_init = ncm2.register_lsp_source}	
	require'nvim_lsp'.gopls.setup{on_init = ncm2.register_lsp_source}
	require'nvim_lsp'.clangd.setup{on_init = ncm2.register_lsp_source}
	require'nvim_lsp'.pyls.setup{on_init = ncm2.register_lsp_source}
	require'nvim_lsp'.dockerls.setup{on_init = ncm2.register_lsp_source}
	require'nvim_lsp'.vimls.setup{on_init = ncm2.register_lsp_source}
	require'nvim_lsp'.tsserver.setup{on_init = ncm2.register_lsp_source}
	require'nvim_lsp'.bashls.setup{on_init = ncm2.register_lsp_source}
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

	set completeopt=menuone,noinsert,noselect
	set pumheight=20
	set shortmess+=c
	inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

	autocmd BufEnter * call ncm2#enable_for_buffer()
endfunc
