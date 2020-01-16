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

au FileType * call s:file_size()
au BufWritePost * call s:file_size()
au FileType * call s:set_stl()

func! s:set_stl()
	if &ft == 'netrw'
		call s:netrwstl()
	else
		call s:norstl()
	endif
endfunc

func! s:netrwstl()
	setl stl=%*\ line:%l/%L
endfunc

func! s:norstl()
	setl stl=%2*%{get(b:,'cur_file_size','')}%*
	setl stl+=%1*\ [b:%n]\ %*
	setl stl+=%*\ %.50f\ %*
	setl stl+=%5*%m%r%h%w%q%*
	setl stl+=%*%=%* 		"左右分割
	if g:lsp_plug == 'coc'
		setl stl+=%*\ %{get(b:,'coc_current_function','')}\ %*
		setl stl+=%5*%{coc#status()}%*
	en
	setl stl+=%3*%y%*
	setl stl+=%2*\ %l\ :\ %c\ %*
	setl stl+=%4*\ %p%%\ /\ %L\ %*
	setl stl+=%1*%{'\ '.(&fenc!=''?&fenc:&enc).'\ '}      "编码1
	setl stl+=%{(&bomb?\",BOM\":\"\")}%*            "编码2
endfunc

function! s:file_size()
    let l:size = getfsize(expand('%'))
    if l:size == 0 || l:size == -1 || l:size == -2
		let l:size = ''
    endif

    if l:size < 1024
        let l:size = l:size.'B'
    elseif l:size < 1024*1024
        let l:size = printf('%.1f', l:size/1024.0).'K'
    elseif l:size < 1024*1024*1024
        let l:size = printf('%.1f', l:size/1024.0/1024.0) . 'M'
    else
        let l:size = printf('%.1f', l:size/1024.0/1024.0/1024.0) . 'G'
    endif

	let b:cur_file_size = l:size
endfunction

call s:set_stl()

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


