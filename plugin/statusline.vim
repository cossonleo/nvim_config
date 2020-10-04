""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: MIT
"     Author: Cosson2017
"    Version: 0.1
" CreateTime: 2018-07-04 11:23:46
" LastUpdate: 2018-07-04 11:23:46
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""statusline"""""""""""""""""""""""""""""""
"au BufRead,BufEnter,BufWritePost,BufCreate * call SetStl()
"au BufRead,BufWritePost,BufCreate * call SetStl()
"au FileType * call SetStl()

if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

lua cossonleo = require'cossonleo'

au FileType netrw,LuaTree setl stl=%*\ line:%l/%L
au BufWritePost,BufReadPost * lua cossonleo.file_name_limit(50)
au BufWritePost,BufReadPost * lua cossonleo.current_file_size(50)

set stl = ""
set stl+=%#CursorLine#%{get(b:,'cur_fsize','')}\ 
set stl+=%#CursorLine#%{get(b:,'fit_len_fname','')}\ 
set stl+=%#CursorLine#%m%r%h%w%q
set stl+=%#CursorLine#%= 		"左右分割
set stl+=%#CursorLine#%{v:lua.cossonleo.lsp_info()}\ 
set stl+=%#CursorLine#%{v:lua.cossonleo.ts_stl()}\ 
set stl+=%#CursorLine#%y\ 
set stl+=%#CursorLine#(%l,%c)/%L\ 
set stl+=%#CursorLine#%{(&fenc!=''?&fenc:&enc)}      "编码1
set stl+=%{(&bomb?\",BOM\":\"\")}            "编码2

""""""""""""""""""""""""""""""""""""""tabline"""""""""""""""""""""""""""""""""""""""
"set tabline=%!MyTabLine()
"
"function! MyTabLine()
"  let s = ''
"  for i in range(tabpagenr('$'))
"    " select the highlighting
"    if i + 1 == tabpagenr()
"      let s .= '%#TabLineSel#'
"    else
"      let s .= '%#TabLine#'
"    endif
"
"    " set the tab page number (for mouse clicks)
"    let s .= '%' . (i + 1) . 'T'
"
"    " the label is made by MyTabLabel()
"    let s .= ' '. (i+1) .' %{MyTabLabel(' . (i + 1) . ')} '
"  endfor
"
"  " after the last tab fill with TabLineFill and reset tab page nr
"  let s .= '%#TabLineFill#%T'
"
"  " right-align the label to close the current tab page
"  if tabpagenr('$') > 1
"    let s .= '%=%#TabLine#%999Xclose'
"  endif
"
"  return s
"endfunction
"
"
"function! MyTabLabel(n)
"	let buflist = tabpagebuflist(a:n)
"	let winnr = tabpagewinnr(a:n)
"	let str = bufname(buflist[winnr - 1])
"	let sub_strs = split(str, "/")
"	let leng = len(sub_strs)
"	if leng < 2
"		return str
"	endif
"	return sub_strs[leng - 2] . '/' . sub_strs[leng - 1]
"endfunction


