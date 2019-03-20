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
	

let s:gui_orange      = "#cb4b16"
hi NormalFloat gui=bold guifg=#cb4b16 guibg=#1A1A1A
"#1A1A1A
"hi link NormalFloat ALEWarningSign
"#002b36
"guibg=#4B0082
"#2F4F4F
"#D3D3D3
"guibg=#002b36
"guibg=#fdf6e3
hi DeniteCL guibg=#3D3D3D
