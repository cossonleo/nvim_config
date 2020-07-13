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

au FileType netrw,LuaTree setl stl=%*\ line:%l/%L
au BufWritePost,BufReadPost * lua require'cossonleo.util'.update_current_file_size()
au BufWritePost,BufReadPost * call s:get_short_fname()


func! s:get_short_fname()
	let b:cur_short_fname = pathshorten(expand('%'))
endfunc

set stl=%4*%{get(b:,'current_file_size','')}/%L%*
set stl+=%1*\ [b:%n]%*
set stl+=%*\ %{get(b:,'cur_short_fname','')}%*
set stl+=%5*%m%r%h%w%q%*
set stl+=%*%=%* 		"左右分割
set stl+=%*%{v:lua.nvim_lsp_status()}\ %*
set stl+=%3*%y%*
set stl+=%2*\ (%l,%c)%*
set stl+=%1*\ %{(&fenc!=''?&fenc:&enc)}      "编码1
set stl+=%{(&bomb?\",BOM\":\"\")}%*            "编码2

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


