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
	Plug 'easymotion/vim-easymotion'
	Plug 'jiangmiao/auto-pairs'
	Plug 'luochen1990/rainbow'
	Plug 'terryma/vim-multiple-cursors'
	Plug 'Yggdroot/LeaderF', {'build': './install.sh'}
	"Plug 'Shougo/denite.nvim'
	"Plug 'CossonLeo/NeoSolarized'
	Plug 'CossonLeo/onedark.vim'
	"Plug 'itchyny/lightline.vim'
	Plug 'haya14busa/incsearch.vim'
	Plug 'tpope/vim-surround'
	Plug 'kshenoy/vim-signature'
	Plug 'Cosson2017/neo-comment.nvim'
	Plug 'Cosson2017/neo-smooth-scroll.nvim'
	Plug 'mhinz/vim-grepper'
	"Plug 'c0r73x/neotags.nvim'
	"Plug 'Cosson2017/vim-ripgrep'
	"Plug 'godlygeek/tabular'
	"Plug 'h-youhei/vim-fcitx'
	"Plug 'osyo-manga/vim-over'
	"Plug 'vim-scripts/fcitx.vim'
	"Plug 'Valloric/ListToggle'
endfunc

func common_plug#config()

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

	colorscheme onedark


	" listtoggle
	"let g:lt_height = 10


	"neotags.nvim
	"let g:neotags_enabled = 1
	
	" incsearch.vim
	map /  <Plug>(incsearch-forward)
	map ?  <Plug>(incsearch-backward)
	map g/ <Plug>(incsearch-stay)



	"fcitx.vim
	set ttimeoutlen=100



	"rainbow
	let g:rainbow_active = 1

	"denite
	"call denite_config#denite_config()

	"leaderf
	let g:Lf_UseMemoryCache = 0
	let g:Lf_ShortcutF = '<leader><leader>'
	let g:Lf_ShortcutB = '<leader>b' "'<c-x>'
	let g:Lf_WindowHeight = 0.7
	nnoremap <leader>f :LeaderfFunction<cr>
	nnoremap <leader>t :LeaderfBufTag<cr>
	let g:Lf_WildIgnore = {
				\ 'dir': ['.svn','.git','.hg'],
				\ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
				\}
	let g:Lf_CommandMap = {'<C-C>': ['<Esc>', '<C-C>']}
	let g:Lf_Ctags ="~/usr/bin/ctags"
    let g:Lf_CtagsFuncOpts = {
            \ 'c': '--c-kinds=fp',
            \ 'rust': '--rust-kinds=f',
            \ }
	"let g:Lf_WindowPosition = 'top'
	"let g:Lf_DefaultExternalTool = "rg"


	"vim-ripgrep "rg 
	"nnoremap <c-a> :Rg<cr>
	"let g:rg_use_local_list = 1
	"let g:rg_window_location = 'belowright'
	"" grepper
	let g:grepper = {}
    let g:grepper.quickfix = 0
	let g:grepper.open = 1
	let g:grepper.highlight = 0
    let g:grepper.tools = ['rg']
    nnoremap <c-a> :Grepper<cr>
    "let g:grepper.prompt_mapping_tool = '<c-a>'

    "let g:grepper.tools =
    "  \ ['git', 'ag', 'ack', 'ack-grep', 'grep', 'findstr', 'rg', 'pt', 'sift']


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


	"AutoPairs
	au FileType rust let b:AutoPairs = {'(':')', '[':']', '{':'}','"':'"', '`':'`'}
	"au FileType rust let g:AutoPairs = {'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`'}

	"vista
	" How each level is indented and what to prepend.
	" This could make the display more compact or more spacious.
	" e.g., more compact: ["▸ ", ""]
	let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

	autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

	" Executive used when opening vista sidebar without specifying it.
	" See all the avaliable executives via `:echo g:vista#executives`.
	let g:vista_default_executive = 'ctags'

	let g:vista_echo_cursor_strategy  = 'floating_win'

	" Set the executive for some filetypes explicitly. Use the explicit executive
	" instead of the default one for these filetypes when using `:Vista` without
	" specifying the executive.
	"let g:vista_executive_for = {
	"  \ 'cpp': 'lcn',
	"  \ 'c': 'lcn',
	"  \ 'php': 'lcn',
	"  \ 'lua': 'lcn'
	"  \ }

	" Declare the command including the executable and options used to generate ctags output
	" for some certain filetypes.The file path will be appened to your custom command.
	" For example:
"	let g:vista_ctags_cmd = {
"				\ 'go': 'ctags --go-kinds=pftvsina',
"				\ }

	" To enable fzf's preview window set g:vista_fzf_preview.
	" The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
	" For example:
	let g:vista_fzf_preview = ['right:50%']

	" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
	let g:vista#renderer#enable_icon = 1

	" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
	let g:vista#renderer#icons = {
	\   "function": "\uf794",
	\   "variable": "\uf71b",
	\  }
endfunc
