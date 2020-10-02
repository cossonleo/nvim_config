if exists("s:is_loaded")
	finish
endif

if get(g:, "colors_name", "") == "onedark"
	"hi link TSField Tag
	hi link TSParameter Tag
	hi link TSParameterReference Tag
	hi link TSField Constant
	hi link TSProperty Constant
	hi link TSConstant  Identifier
	hi link TSKeyword Label
	hi link TSFuncMacro Keyword
endif
"hi link TSConstant Float
"hi TSField guifg=#56C1C2
"hi TSField guifg=#20B2AA


