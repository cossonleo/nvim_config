lua require 'cossonleo'

source common_plug.vim
source builtin_lsp.vim
"source coc_plug.vim
 
" 打开时光标放在上次退出时的位置
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\   exe "normal g'\"" |
\ endif

augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END


let g:lsp_plug = '' "'coc'

if has('win32') || has('win64')
	set guifont=:h20
	let g:plug_dir = '~/AppData/Local/nvim/plugged'
else
	let g:plug_dir = '~/.config/nvim/plugged'
endif

"""""""""""""""""""""""下面时插件设置"""""""""""""""""""""''"""
call plug#begin(g:plug_dir)
doautocmd User PlugAddEvent
call plug#end()
doautocmd User PlugEndEvent

menu project.Files :16Lexplore<cr>
menu ToolBar.Project :16Lexplore<cr>

