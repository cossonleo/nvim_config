""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: MIT
"     Author: Cosson
"    Version: 0.1 
" CreateTime: 2018-02-28 10:24:04
" LastUpdate: 2018-02-28 10:24:04
"       Desc: neovim init config
""""""""""""""""""""""""""""""""""""""""""

set cul 
set number
set relativenumber
set showcmd
set cmdheight=2
set ruler
set confirm
set scrolloff=0
set tabstop=4
set shiftwidth=4
set clipboard+=unnamedplus " 系统安装xclip或xsel
set hidden
set completeopt=longest,menu 
set updatetime=500
set selection=inclusive "exclusive inclusive old
set nohlsearch
set termguicolors
"set background=dark
set background=dark
set cursorline
set cursorcolumn
"set mouse=a
"set ignorecase
set smartcase
set fo=""
"set list
"set foldmethod=syntax


" neovim python支持 需要sudo pip3 install --upgrade neovim 
let g:python3_host_prog = '/usr/bin/python3'
let g:python3_host_skip_check = 1
let g:loaded_python_provider = 0

let mapleader=' '

" map
noremap <c-s> :w<cr>
nnoremap <F5> :make<cr>
inoremap <c-s> <esc>:w<cr>
"noremap <c-a> :wa<cr>
"inoremap <c-a> <esc>:wa<cr>
tnoremap <Esc> <C-\><C-n>
tnoremap <C-w><C-w> <C-\><C-N><C-w><C-w>
tnoremap <C-w>h <C-\><C-N><C-w>h
tnoremap <C-w>j <C-\><C-N><C-w>j
tnoremap <C-w>k <C-\><C-N><C-w>k
tnoremap <C-w>l <C-\><C-N><C-w>l
inoremap <c-o> <c-x><c-o>
nnoremap <leader>p :pc<cr>
 

"completion
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

if has("autocmd")   " 打开时光标放在上次退出时的位置
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal g'\"" |
        \ endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



"""""""""""""""""""""""下面时插件设置"""""""""""""""""""""''"""

call plug#begin('~/.config/nvim/plugged')

"""""""""""""""syntax""""""""""""""""""""""
" 内容对齐
Plug 'godlygeek/tabular'
" incsearch.vim
Plug 'haya14busa/incsearch.vim'
" 移动光标
Plug 'easymotion/vim-easymotion'
" 自动完成另一半
Plug 'jiangmiao/auto-pairs'
"括号的颜色
Plug 'luochen1990/rainbow'
" 多指针操作
Plug 'terryma/vim-multiple-cursors'
"surround
Plug 'tpope/vim-surround'
"listtoggle
Plug 'Valloric/ListToggle'
"主题
Plug 'iCyMind/NeoSolarized'
" vim-over
"Plug 'osyo-manga/vim-over'
"fcitx.vim
Plug 'vim-scripts/fcitx.vim'
"vim-signature
"Plug 'kshenoy/vim-signature'
"leaderf
"Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
Plug 'Shougo/denite.nvim'
"git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'gregsexton/gitv'
Plug 'vim-scripts/TaskList.vim'
"
"rg
Plug 'jremmen/vim-ripgrep'

""""""""""""""""""language"""""""""""""""""""

Plug 'Shougo/echodoc.vim'
"Plug 'Cosson2017/vim-lsc'
Plug 'Cosson2017/vim-lsp'
Plug 'prabirshrestha/async.vim'

"c family highlight
"Plug 'arakashic/chromatica.nvim' ", {'for':['cpp', 'h', 'hpp', 'c']}
"Plug 'rhysd/vim-clang-format', {'for':['cpp', 'h', 'hpp', 'c']}

"qml
Plug 'peterhoeg/vim-qml', {'for':['qml']}
"wx program
Plug 'chemzqm/wxapp.vim'
"tagbar 
Plug 'majutsushi/tagbar'

"ale
"Plug 'w0rp/ale'

"markdown
"Plug 'plasticboy/vim-markdown'
"Plug 'JamshedVesuna/vim-markdown-preview'
"
"mine
Plug 'Cosson2017/neo-comment.nvim'
Plug 'Cosson2017/neo-smooth-scroll.nvim'
Plug 'Cosson2017/nvim-completor'
Plug 'Cosson2017/neo-debuger'

call plug#end()            




" netrw
nnoremap <leader>e :20Lexplore<cr>
let g:netrw_list_hide = '.*\.swp$'
let g:netrw_preview   = 1
let g:netrw_liststyle = 3
"let g:netrw_winsize   = 16



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

"neosnippet
"imap <c-j>     <Plug>(neosnippet_expand_or_jump)
"smap <c-j>     <Plug>(neosnippet_expand_or_jump)
"xmap <c-j>     <Plug>(neosnippet_expand_target)
"smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
"\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" For conceal markers.
"if has('conceal')
"  set conceallevel=2 concealcursor=niv
"endif
"let g:neosnippet#enable_completed_snippet=1
"let g:neosnippet#snippets_directory='~/.config/nvim/plugged/neosnippet-snippets/neosnippets'


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

"nvim-complete-manager
let g:cm_refresh_length = 1
let g:cm_matcher = {'module': 'cm_matchers.fuzzy_matcher', 'case': 'smartcase'}
let g:cm_sources_override = {
			    \ 'cm-tags': {'enable':0},
				\ 'cm-jedi': {'enable': 0},
				\ 'cm-gocode': {'enable':0},
				\ 'cm-bufkeyword': {'enable':0},
				\ 'cm-keyword-continue': {'enable': 0},
				\ 'cm-tmux': {'enable': 0},
				\ 'cm-filepath': {'enable': 0},
			    \ }

"deoplete
let g:deoplete#enable_at_startup = 1
"let g:deoplete#auto_complete_start_length = 1
"call deoplete#custom#set('go', 'rank', 9999)
"call deoplete#custom#set('rtags', 'rank', 9999)
let g:deoplete#auto_complete_delay=0

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

"git

"markdown
let vim_markdown_preview_hotkey='<C-m>'
let vim_markdown_preview_use_xdg_open=1

"chromatica
"au FileType h,hpp,c,cpp ChromaticaStart
let g:chromatica#enable_at_startup = 0
let g:chromatica#highlight_feature_level = 1
let g:chromatica#responsive_mode=1
let g:chromatica#delay_ms = 50
let g:chromatica#libclang_path = '/usr/lib/libclang.so'

"echodoc
let g:echodoc_enable_at_startup = 1

"asyncomplete
let g:asyncomplete_completion_delay = 25

"neogdb
let g:neobugger_leader = '<leader>'

"rg 
nnoremap <c-a> :Rg<cr>

"tagbar
nnoremap <F12> :TagbarToggle<CR>
let g:tagbar_autoclose = 1
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_ctags_bin = $HOME . "/usr/bin/ctags"
let g:tagbar_type_go = {
			\ 'ctagstype': 'go',
			\ 'kinds': [
			\ 'p:package',
			\ 'i:imports:1',
			\ 'c:constants',
			\ 'v:variables',
			\ 't:types',
			\ 'w:fields',
			\ 'm:methods',
			\ 'f:functions',
			\ 'r:constructor',
			\ 'n:interfaces',
			\ 'e:embed',
			\],
			\ 'sro':'.',
			\ 'kind2scope':{
				\ 't':'ctype',
				\ 'n': 'ntype',
			\},
			\ 'ctagsbin': 'gotags',
			\ 'ctagsargs': '-sort -silent',
		\}

"p  packages
"f  functions
"c  constants
"t  types
"v  variables
"s  structs
"i  interfaces
"m  struct members
"M  struct anonymous members
"u  unknown


"nvim-completor
let g:load_nvim_completor_lsp = 1
let g:load_vim_lsp = 1
