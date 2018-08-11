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
au FileType * call SetStl()

func! SetStl()
	if &ft == 'netrw'
		call s:netrwstl()
	elseif &ft == ''
	else
		call s:norstl()
	endif
endfunc

func! s:netrwstl()
	setl stl=%5*\ line:%l/%L
endfunc

"状态行
func! s:norstl()
	setl stl=%7*\ %{File_size()}\ %*
	setl stl+=%1*\ [buf:%n]\ %*
	setl stl+=%2*\ %f\ %*
	setl stl+=%3*\ %m%r%h%w%q\ %*
	setl stl+=%8*%=%* 		"左右分割
	setl stl+=%4*\ %y\ %*
	setl stl+=%5*\ line:%l/%L
	setl stl+=\ [%p%%]
	setl stl+=\ col:%c\ %*
	setl stl+=%6*\ %{''.(&fenc!=''?&fenc:&enc).''}\       "编码1
	setl stl+=\ %{(&bomb?\",BOM\":\"\")}%*            "编码2
endfunc

function! File_size()
    let l:size = getfsize(expand('%'))
    if l:size == 0 || l:size == -1 || l:size == -2
        return ''
    endif
    if l:size < 1024
        return l:size.'B'
    elseif l:size < 1024*1024
        return printf('%.1f', l:size/1024.0).'K'
    elseif l:size < 1024*1024*1024
        return printf('%.1f', l:size/1024.0/1024.0) . 'M'
    else
        return printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'G'
    endif
endfunction

hi User1 guifg=#dddddd  guibg=#b58900  gui=bold
hi User2 guifg=#8a8a8a  guibg=#002b36  gui=bold
hi User3 guifg=#dc322f  guibg=#002b36  gui=bold
hi User4 guifg=#dddddd  guibg=#d33682  gui=bold
hi User5 guifg=#dddddd  guibg=#6c71c4  gui=bold
hi User6 guifg=#dddddd  guibg=#859900  gui=bold
hi User7 guifg=#dddddd  guibg=#268bd2  gui=bold
hi User8 guifg=#dddddd  guibg=#002b36  gui=bold


""""""""""""""""""""""""""""""""""""""tabline"""""""""""""""""""""""""""""""""""""""
set tabline=%!MyTabLine()

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' '. (i+1) .' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction


function! MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let str = bufname(buflist[winnr - 1])
	let sub_strs = split(str, "/")
	let leng = len(sub_strs)
	if leng < 2
		return str
	endif
	return sub_strs[leng - 2] . '/' . sub_strs[leng - 1]
endfunction
