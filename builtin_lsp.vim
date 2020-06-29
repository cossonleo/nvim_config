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

autocmd User PlugAddEvent call <SID>add()
autocmd User PlugEndEvent call <SID>config()

func! s:add()
	Plug 'neovim/nvim-lsp'
	Plug 'jiangmiao/auto-pairs'
	Plug 'cossonleo/nvim-completor'
	Plug 'Shougo/echodoc.vim'
	Plug 'haorenW1025/diagnostic-nvim'
endf

func! builtin_lsp#reference()
	lua vim.lsp.buf.references()
	call nvim_command("copen")
endfunc

func s:config()
lua << EOF
	require('vim.lsp.log').set_level(4)
	local nvim_lsp = require('nvim_lsp')
	local on_attach = function()
		require('diagnostic').on_attach()
	end
	nvim_lsp.rust_analyzer.setup{on_attach=on_attach}
	nvim_lsp.gopls.setup{
		on_attach=on_attach,
		settings = {
			gopls = {
				usePlaceholders = true,	
				completeUnimported = true,
			}
		}
	}
	nvim_lsp.clangd.setup{on_attach=on_attach}
	nvim_lsp.pyls.setup{on_attach=on_attach}
	nvim_lsp.dockerls.setup{on_attach=on_attach}
	nvim_lsp.vimls.setup{on_attach=on_attach}
	nvim_lsp.tsserver.setup{on_attach=on_attach}
	nvim_lsp.bashls.setup{on_attach=on_attach}
	nvim_lsp.rust_analyzer.setup{on_attach=on_attach}
	nvim_lsp.sumneko_lua.setup{on_attach=on_attach}
	nvim_lsp.jsonls.setup{
		on_attach=on_attach,
		settings = {
			json = {
				format = {
					enable = true
				}
			}
		}
	}
EOF

	autocmd Filetype rust,go,c,cpp,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc

	nnoremap <silent> ]d 	<cmd>lua vim.lsp.buf.definition()<CR>
	nnoremap <silent> [d    <cmd>lua vim.lsp.buf.implementation()<CR>
	nnoremap <silent> <leader>r    <cmd>call builtin_lsp#reference()<CR>
	nnoremap <silent> gc    <cmd>lua vim.lsp.buf.rename()<CR>
	nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
	nnoremap <silent> gq 	<cmd>lua vim.lsp.buf.formatting()<cr>
	"nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>

	inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

	let g:echodoc#enable_at_startup = 1
	let g:echodoc#type = "floating"

	let g:diagnostic_insert_delay = 1
	call sign_define("LspDiagnosticsErrorSign", {"text" : "E", "texthl" : "LspDiagnosticsError"})
	call sign_define("LspDiagnosticsWarningSign", {"text" : "W", "texthl" : "LspDiagnosticsWarning"})
	call sign_define("LspDiagnosticInformationSign", {"text" : "I", "texthl" : "LspDiagnosticsInformation"})
	call sign_define("LspDiagnosticHintSign", {"text" : "H", "texthl" : "LspDiagnosticsHint"})
	let g:diagnostic_enable_virtual_text = 1
	let g:space_before_virtual_text = 5
	let g:space_before_virtual_text = 5
	nnoremap <silent> ]e <cmd>NextDiagnosticCycle<cr>
	nnoremap <silent> [e <cmd>PrevDiagnosticCycle<cr>
	nnoremap <silent> <leader>d <cmd>OpenDiagnostic<cr>
endfunc
