""""""""""""""""""""""""""""""""""""""""""

set cursorline
"set cursorcolumn
set number
set relativenumber
set showcmd
set cmdheight=2
set ruler
set confirm
set scrolloff=0
set tabstop=4
set shiftwidth=4
set clipboard=unnamedplus " 系统安装xclip或xsel
set hidden
set completeopt=longest,menu
"set updatetime=500
set selection=inclusive "exclusive inclusive old
set nohlsearch
set termguicolors
"set mouse=a
"set ignorecase
set smartcase
set fo=""
"set list
"set foldmethod=syntax

set maxmempattern=10000
set wildmenu
set wildmode=longest,full
"set wildmode=list:longest,full
set fileencodings=utf-8,ucs-bom,gb2312,gbk,gb18030,latin1
"set termencoding=encoding
"set encoding=prc

set diffopt+=vertical,algorithm:patience

" neovim python支持 需要sudo pip3 install --upgrade neovim 
"let g:python3_host_prog = '/usr/bin/python3'
"let g:python3_host_skip_check = 1
"let g:loaded_python_provider = 0

"let mapleader=' '

" map
"noremap <c-a> :wa<cr>
"inoremap <c-a> <esc>:wa<cr>
tnoremap <Esc> <C-\><C-n>
tnoremap <C-w><C-w> <C-\><C-N><C-w><C-w>
tnoremap <C-w>h <C-\><C-N><C-w>h
tnoremap <C-w>j <C-\><C-N><C-w>j
tnoremap <C-w>k <C-\><C-N><C-w>k
tnoremap <C-w>l <C-\><C-N><C-w>l
 
if has("autocmd")   " 打开时光标放在上次退出时的位置
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal g'\"" |
        \ endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" netrw
nnoremap <leader>e :18Lexplore<cr>
let g:netrw_list_hide = '.*\.swp$'
let g:netrw_preview   = 1
let g:netrw_liststyle = 3
let g:netrw_banner = 0
"let g:netrw_winsize   = 16


augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END


let g:lsp_plug = '' "'coc'

"""""""""""""""""""""""下面时插件设置"""""""""""""""""""""''"""
call plug#begin('~/.config/nvim/plugged')
	call common_plug#add()

	if g:lsp_plug == 'coc'
		call coc_plug#add()
	else
		call builtin_lsp#add()
	en
call plug#end()

call common_plug#config()

if g:lsp_plug == 'coc'
	call coc_plug#config()
else
	call builtin_lsp#config()
en

menu project.Files :16Lexplore<cr>
menu ToolBar.Project :16Lexplore<cr>

if has('win32') || has('win64')
	set guifont=:h20
endif
