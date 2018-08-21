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
	call dein#add('easymotion/vim-easymotion')
	call dein#add('jiangmiao/auto-pairs')
	call dein#add('Valloric/ListToggle')
	call dein#add('luochen1990/rainbow')
	call dein#add('terryma/vim-multiple-cursors')
	call dein#add('Yggdroot/LeaderF', {'build': './install.sh'})
	call dein#add('iCyMind/NeoSolarized')
	call dein#add('godlygeek/tabular')
	call dein#add('haya14busa/incsearch.vim')
	call dein#add('tpope/vim-surround')
	call dein#add('osyo-manga/vim-over')
	call dein#add('vim-scripts/fcitx.vim')
	call dein#add('kshenoy/vim-signature')
	call dein#add('jremmen/vim-ripgrep')
	call dein#add('Cosson2017/neo-comment.nvim')
	call dein#add('Cosson2017/neo-smooth-scroll.nvim')
endfunc

func common_plug#config()

	"NeoSolarized
	let g:neosolarized_contrast = "normal"
	let g:neosolarized_visibility = "normal"
	let g:neosolarized_vertSplitBgTrans = 1
	let g:neosolarized_bold = 1
	let g:neosolarized_underline = 1
	let g:neosolarized_italic = 0
	colorscheme NeoSolarized



	" listtoggle
	let g:lt_height = 10




	" incsearch.vim
	map /  <Plug>(incsearch-forward)
	map ?  <Plug>(incsearch-backward)
	map g/ <Plug>(incsearch-stay)



	"fcitx.vim
	set ttimeoutlen=100



	"rainbow
	let g:rainbow_active = 1

	"denite
	"nnoremap <c-p> :Denite file/rec<cr>
	"nnoremap <c-b> :Denite buffer<cr>
	"call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
	"call denite#custom#map(
	"	  \ 'insert',
	"	  \ '<c-j>',
	"	  \ '<denite:move_to_next_line>',
	"	  \ 'noremap'
	"	  \)
	"call denite#custom#map(
	"	  \ 'insert',
	"	  \ '<c-k>',
	"	  \ '<denite:move_to_previous_line>',
	"	  \ 'noremap'
	"	  \)

	"leaderf
	let g:Lf_UseMemoryCache = 0
	let g:Lf_ShortcutF = '<c-p>'
	let g:Lf_ShortcutB = '<c-b>'
	nnoremap <c-f> :LeaderfFunction<cr>
	nnoremap <c-g> :LeaderfBufTag<cr>
	let g:Lf_WildIgnore = {
				\ 'dir': ['.svn','.git','.hg'],
				\ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
				\}
	let g:Lf_CommandMap = {'<C-C>': ['<Esc>', '<C-C>']}
	let g:Lf_Ctags ="~/usr/bin/ctags"




	"tabular
	let g:tabular_loaded = 1


	"easymotion
	let g:EasyMotion_do_mapping = 0 " Disable default mappings

	" Jump to anywhere you want with minimal keystrokes, with just one key binding.
	" `s{char}{label}`
	nmap s <Plug>(easymotion-overwin-f)
	"nmap s <Plug>(easymotion-s)
	" or
	" `s{char}{char}{label}`
	" Need one more keystroke, but on average, it may be more comfortable.
	"nmap <leader>s <Plug>(easymotion-overwin-f2)

	" Turn on case insensitive feature
	let g:EasyMotion_smartcase = 1

	" JK motions: Line motions
	map <Leader>j <Plug>(easymotion-j)
	map <Leader>k <Plug>(easymotion-k)

	"rg 
	nnoremap <c-a> :Rg<cr>
endfunc
