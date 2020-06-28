lua require 'cossonleo'
 
if has("autocmd")   " 打开时光标放在上次退出时的位置
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal g'\"" |
        \ endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


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

