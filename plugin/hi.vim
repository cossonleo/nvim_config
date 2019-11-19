if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

let s:onedark_colors = onedark#GetColors()

"hi PromInputHl gui=bold guifg=#cb4b16 guibg=#1A1A1A
hi PromInputHl gui=bold
exe "hi PromHl guibg=#000000 guifg=" . s:onedark_colors.blue.gui . " gui=bold"

hi NormalFloat guibg=#1A1A1A
hi DeniteCL guibg=#3D3D3D

"hi link LspError ALEErrorSign
hi link LspError ErrorMsg
hi link LspWarning WarningMsg

hi StatusLine guifg=#8a8a8a  guibg=#1A1A1A  gui=bold
hi StatusLineNC guifg=#8a8a8a  guibg=#1A1A1A  gui=bold

exe "hi User1 guifg=#000000 guibg=" . s:onedark_colors.purple.gui . " gui=bold"
exe "hi User2 guifg=#000000 guibg=" . s:onedark_colors.blue.gui . " gui=bold"
exe "hi User3 guifg=#000000 guibg=" . s:onedark_colors.yellow.gui . " gui=bold"
exe "hi User4 guifg=#000000 guibg=" . s:onedark_colors.green.gui . " gui=bold"
exe "hi User5 guifg=#000000 guibg=" . s:onedark_colors.red.gui . " gui=bold"
exe "hi User6 guifg=#000000 guibg=" . s:onedark_colors.white.gui .  " gui=bold"

"hi User1 guifg=#C678DD gui=bold
"hi StatusBlue guifg=#61AFEF gui=bold
"hi StatusYellow guifg=#E5C07B
"hi StatusGreen guifg=#98C379
"hi StatusRed guifg=#BE5046

