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
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'Shougo/deoplete-lsp'
	Plug 'Shougo/neosnippet.vim'
	Plug 'Shougo/neosnippet-snippets'
endf

func builtin_lsp#config()
lua << EOF
	require'nvim_lsp'.rust_analyzer.setup{}	
	require'nvim_lsp'.gopls.setup{}
	require'nvim_lsp'.clangd.setup{}
	require'nvim_lsp'.pyls.setup{}
	require'nvim_lsp'.dockerls.setup{}
	require'nvim_lsp'.vimls.setup{}
	require'nvim_lsp'.tsserver.setup{}
	require'nvim_lsp'.bashls.setup{}
EOF

	autocmd Filetype rust,go,c,cpp,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc

	nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.declaration()<CR>
	nnoremap <silent> gd 	<cmd>lua vim.lsp.buf.definition()<CR>
	nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
	nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
	nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
	nnoremap <silent> gc    <cmd>lua vim.lsp.buf.rename()<CR>
	nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
	"nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>

	let g:deoplete#enable_at_startup = 1
	call deoplete#custom#option('smart_case', v:true)

	" <CR>: close popup and save indent.
	inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
	func! s:my_cr_function() abort
	  return deoplete#close_popup() . "\<CR>"
	endf

	inoremap <silent><expr> <TAB>
		\ pumvisible() ? "\<C-n>" :
		\ <SID>check_back_space() ? "\<TAB>" :
		\ deoplete#manual_complete()

	func! s:check_back_space() abort "{{{
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~ '\s'
	endf "}}}

	" Plugin key-mappings.
	" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
	imap <C-j>     <Plug>(neosnippet_expand_or_jump)
	smap <C-j>     <Plug>(neosnippet_expand_or_jump)
	xmap <C-j>     <Plug>(neosnippet_expand_target)

	" SuperTab like snippets behavior.
	" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
	"imap <expr><TAB>
	" \ pumvisible() ? "\<C-n>" :
	" \ neosnippet#expandable_or_jumpable() ?
	" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
	smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

	" For conceal markers.
	if has('conceal')
	  set conceallevel=2 concealcursor=niv
	en
endfunc
