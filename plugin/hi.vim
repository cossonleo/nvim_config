if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

hi User1 guifg=#dddddd  guibg=#b58900  gui=bold
hi User2 guifg=#8a8a8a  guibg=#1A1A1A  gui=bold
hi User3 guifg=#dc322f  guibg=#1A1A1A  gui=bold
hi User4 guifg=#dddddd  guibg=#d33682  gui=bold
hi User5 guifg=#dddddd  guibg=#6c71c4  gui=bold
hi User6 guifg=#dddddd  guibg=#859900  gui=bold
hi User7 guifg=#dddddd  guibg=#268bd2  gui=bold
hi User8 guifg=#dddddd  guibg=#1A1A1A  gui=bold

hi link LspError ALEErrorSign
hi link LspWarning ALEWarningSign
	
hi NormalFloat gui=bold guifg=#268bd2 guibg=#002b36
"guibg=#fdf6e3
