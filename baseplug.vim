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

autocmd User PlugAddEvent call <SID>add()
autocmd User PlugEndEvent call <SID>config()

func s:add()
	Plug 'luochen1990/rainbow'
	Plug 'joshdick/onedark.vim'
	Plug 'machakann/vim-sandwich'
	Plug 'kshenoy/vim-signature'
	Plug 'voldikss/vim-floaterm'
	Plug 'terryma/vim-multiple-cursors'
	Plug 'whiteinge/diffconflicts'
	Plug 'cossonleo/dirdiff.nvim'
	Plug 'cossonleo/neo-comment.nvim'
	Plug 'cossonleo/neo-smooth-scroll.nvim'
	Plug 'voldikss/vim-translator'
endfunc


func s:config()


	let g:onedark_color_overrides = {
				\ "black": {"gui": "#000000", "cterm": "235", "cterm16": 0}
				\ }
	colorscheme onedark
	
	let g:EasyMotion_do_mapping = 0

	"rainbow
	let g:rainbow_active = 1

	" vim-floaterm
	let g:floaterm_winblend = 10
	"let g:floaterm_width = &columns * 2 / 3
	"let g:floaterm_height = &lines * 3 / 4
	let g:floaterm_width = 0.7
	let g:floaterm_height = 0.8
	let g:floaterm_position = 'center'
	let g:floaterm_keymap_toggle = '<F4>'
	let g:floaterm_keymap_new    = '<leader><F4>'
	let g:floaterm_keymap_next   = '<F16>'
	let g:floaterm_border_color = "#FFFFFF"
	autocmd User Startified setlocal buflisted

	"translator
	nnoremap <silent><leader>a :TranslateW<CR>

endf

