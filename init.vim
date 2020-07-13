let s:config_home = stdpath("config")

lua my_init_lua = require 'cossonleo'

 
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

if &term =~# '^screen'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

"""""""""""""""""""""""下面时插件设置"""""""""""""""""""""''"""
call plug#begin(s:config_home . "/plugged")
doautocmd User PlugAddEvent
call plug#end()
doautocmd User PlugEndEvent
