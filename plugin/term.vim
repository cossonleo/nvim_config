""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: 
"     Author: 
"    Version: 
" CreateTime: 2018-08-06 17:31:49
" LastUpdate: 2018-08-06 17:31:49
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""

if exists("s:is_load")
	finish
endif
let s:is_load = 1

func s:open_terminal()
	exe ":tabnew"
	exe ":terminal"
	exe "normal a"
endfunc

command! -bar -bang T call <SID>open_terminal()
command! -bar -bang Te call <SID>open_terminal()
