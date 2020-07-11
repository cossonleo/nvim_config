let s:config_home = stdpath("config")

lua my_init_lua = require 'cossonleo'

"lua require'baseplug'
"lua require'navplug'
"lua require'devplug'

" source 只认字符串
"exe 'source ' . s:config_home . '/baseplug.vim'
"exe 'source ' . s:config_home . '/navplug.vim'
"exe 'source ' . s:config_home . '/devplug.vim'
"source s:config_home . '/coc_plug.vim'
 
" 打开时光标放在上次退出时的位置
autocmd BufReadPost *
\ if line("'\"") > 0 && line ("'\"") <= line("$") |
\   exe "normal g'\"" |
\ endif

autocmd Filetype rust,go,c,cpp,vim setlocal omnifunc=v:lua.vim.lsp.omnifunc

augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END

if has('win32') || has('win64')
	set guifont=:h20
endif

"""""""""""""""""""""""下面时插件设置"""""""""""""""""""""''"""
call plug#begin(s:config_home . "/plugged")
doautocmd User PlugAddEvent
call plug#end()
doautocmd User PlugEndEvent

