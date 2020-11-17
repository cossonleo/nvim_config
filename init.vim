let s:config_home = stdpath("config")

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

lua require 'cossonleo'

"inoremap <F5> <C-R>=ListMonths()<CR>
"
"func! ListMonths()
"lua << EOF
"local ts_utils = require 'nvim-treesitter.ts_utils'
"local current_node = ts_utils.get_node_at_cursor()
"local start_row, _, _ = current_node:start()
"local count = 0
"for child_node in current_node:iter_children() do
"	local rr, _, _ = child_node:start()
"	count = count + 1
"	print(rr .. " " .. count)
"end
"--print(start_row)
"EOF
"return ""
"endfunc
"
au FileType * lua require('ts_ext').on_filetype()
