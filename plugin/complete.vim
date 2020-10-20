""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: MIT
"     Author: Cosson2017
"    Version: 0.2
" CreateTime: 2018-03-07 12:13:15
" LastUpdate: 2018-03-18 18:19:05
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""
if exists('g:nvim_completor_load')
    finish
endif
let g:nvim_completor_load = 1

hi link SnippetHl Comment

lua << EOF
local ncp = require('nvim-completor')
ncp.on_load()
ncp.set_log_level(4)
require("complete-src")
EOF

let s:ncp = "require('nvim-completor')"

exe 'autocmd TextChangedP * lua ' . s:ncp . '.on_text_changed_p()'
exe 'autocmd TextChangedI * lua ' . s:ncp . '.on_text_changed_i()'
exe 'autocmd InsertEnter * lua ' . s:ncp . '.on_insert()'
exe 'autocmd InsertLeave * lua ' . s:ncp . '.on_insert_leave()'
"autocmd CompleteDone * lua ncp.on_complete_done()
exe 'autocmd BufEnter * lua ' . s:ncp. '.on_buf_enter()'


"inoremap <expr> <cr> (pumvisible() ? <C-R>=TComplete()<CR> : "\<CR>")
inoremap <cr> <c-r>=CompleteDone()<CR>

exe 'inoremap <m-j> <c-o>:lua ' . s:ncp . '.jump_to_next_pos()<cr>'

func! CompleteDone()
	if pumvisible()
		let l:str = s:ncp . ".on_complete_done()"
		call luaeval(l:str)
		return "\<c-y>"
	else
		return "\<cr>"
	endif
endfunc
