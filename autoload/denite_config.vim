""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: 
"     Author: 
"    Version: 
" CreateTime: 2019-03-27 16:53:43
" LastUpdate: 2019-03-27 16:53:43
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""

if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

function! s:denite_grep(...) abort
	let l:input_word = ""
	if len(a:000) == 0
		let l:input_word = expand("<cword>")
	else
		let l:input_word = a:000[0]
	endif
	exe s:denite_float . " -input=" . l:input_word . " " . "grep"
	"echo l:input_word
endfunction

function! s:denite_outline()
	call denite#custom#var('outline', 'command', ['ctags', '--go-kinds=-Mm', '--rust-kinds=-m'])
endfunction

function! s:denite_grep()
	call denite#custom#var('grep', 'command', ['rg'])
	call denite#custom#var('grep', 'default_opts',
			\ ['-i', '--vimgrep', '--no-heading'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
endfunction

function! denite_config#denite_config()
	let s:denite_float = ' :Denite  -highlight-mode-insert=DeniteCL -split="floating" -winrow=`&lines / 8` -winheight=`&lines * 3 / 4` '
	exe 'nnoremap <leader><leader>' . s:denite_float . 'file/rec<cr>'
	exe 'nnoremap <leader>b' . s:denite_float . 'buffer<cr>'
	exe 'nnoremap <leader>s' . s:denite_float . 'documentSymbol<cr>'
	exe 'nnoremap <leader>t' . s:denite_float . 'outline<cr>'
	exe 'nnoremap <leader>f' . s:denite_float . 'references<cr>'

	command! -nargs=* DeniteGrep call <SID>denite_grep(<f-args>)
	nnoremap <leader>a :DeniteGrep 

	call s:denite_outline()
	call s:denite_grep()

	call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

	call denite#custom#map(
	      \ 'insert',
	      \ '<C-j>',
	      \ '<denite:move_to_next_line>',
	      \ 'noremap'
	      \)
	call denite#custom#map(
	      \ 'insert',
	      \ '<C-k>',
	      \ '<denite:move_to_previous_line>',
	      \ 'noremap'
	      \)
endfunction
