if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

let s:status_hi = ' guifg=#8a8a8a  guibg=#1A1A1A  gui=bold'
exe 'hi StatusLineHi '. s:status_hi

hi NormalFloat gui=bold guifg=#cb4b16 guibg=#1A1A1A
hi DeniteCL guibg=#3D3D3D

hi link LspError ALEErrorSign
hi link LspWarning ALEWarningSign
hi link User2 StatusLineHi
