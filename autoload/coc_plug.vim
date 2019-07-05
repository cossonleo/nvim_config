""""""""""""""""""""""""""""""""""""""""""
"    LICENSE: 
"     Author: 
"    Version: 
" CreateTime: 2019-07-05 17:23:48
" LastUpdate: 2019-07-05 17:23:48
"       Desc: 
""""""""""""""""""""""""""""""""""""""""""

if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1


function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
	execute 'h '.expand('<cword>')
  else
	call CocAction('doHover')
  endif
endfunction
	

func coc_plug#coc_config()
	" You will have bad experience for diagnostic messages when it's default 4000.
	set updatetime=300
	
	" don't give |ins-completion-menu| messages.
	set shortmess+=c
	
	" always show signcolumns
	set signcolumn=yes
	
	" Use tab for trigger completion with characters ahead and navigate.
	" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
	inoremap <silent><expr> <TAB>
	      \ pumvisible() ? "\<C-n>" :
	      \ <SID>check_back_space() ? "\<TAB>" :
	      \ coc#refresh()
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
	
	" Use <c-space> to trigger completion.
	"inoremap <silent><expr> <c-space> coc#refresh()
	
	" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
	" Coc only does snippet and additional edit on confirm.
	inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
	
	" Use `[c` and `]c` to navigate diagnostics
	nmap <silent> [c <Plug>(coc-diagnostic-prev)
	nmap <silent> ]c <Plug>(coc-diagnostic-next)
	
	" Remap keys for gotos
	nmap <silent> gd <Plug>(coc-definition)
	"nmap <silent> gy <Plug>(coc-type-definition)
	"nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gf <Plug>(coc-references)
	
	" Use K to show documentation in preview window
	nnoremap <silent> K :call <SID>show_documentation()<CR>
	
	" Highlight symbol under cursor on CursorHold
	autocmd CursorHold * silent call CocActionAsync('highlight')
	
	" Remap for rename current word
	nmap gr <Plug>(coc-rename)
	
	" Remap for format selected region
	"xmap <leader>f  <Plug>(coc-format-selected)
	"nmap <leader>f  <Plug>(coc-format-selected)
	"setl formatexpr = CocAction('format')
	
	augroup mygroup
	  autocmd!
	  " Setup formatexpr specified filetype(s).
	  "autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	  " Update signature help on jump placeholder
	  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end
	
	" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)
	
	" Remap for do codeAction of current line
	nmap <leader>ac  <Plug>(coc-codeaction)
	" Fix autofix problem of current line
	nmap <leader>qf  <Plug>(coc-fix-current)
	
	" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
	nmap <silent> <TAB> <Plug>(coc-range-select)
	xmap <silent> <TAB> <Plug>(coc-range-select)
	xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)
	
	" Use `:Format` to format current buffer
	command! -nargs=0 Format :call CocAction('format')
	nmap gq :Format<cr> 
	
	" Use `:Fold` to fold current buffer
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)
	
	" use `:OR` for organize import of current buffer
	command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
	
	" Add status line support, for integration with other plugin, checkout `:h coc-status`
	"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
	
	" Using CocList
	" Show all diagnostics
	"nnoremap <silent> <leader>a  :<C-u>CocList diagnostics<cr>
	" Manage extensions
	"nnoremap <silent> <leader>e  :<C-u>CocList extensions<cr>
	" Show commands
	"nnoremap <silent> <leader>c  :<C-u>CocList commands<cr>
	" Find symbol of current document
	nnoremap <silent> <leader>o  :<C-u>CocList outline<cr>
	" Search workspace symbols
	nnoremap <silent> <leader>s  :<C-u>CocList -I symbols<cr>
	" Do default action for next item.
	"nnoremap <silent> <leader>j  :<C-u>CocNext<CR>
	" Do default action for previous item.
	"nnoremap <silent> <leader>k  :<C-u>CocPrev<CR>
	" Resume latest coc list
	"nnoremap <silent> <leader>p  :<C-u>CocListResume<CR>
	"
	nnoremap <leader><leader> :CocList files<cr>

	nnoremap <leader>b :CocList buffers<cr>


	" Use <C-l> for trigger snippet expand.
	imap <C-l> <Plug>(coc-snippets-expand)
	
	" Use <C-j> for select text for visual placeholder of snippet.
	vmap <C-j> <Plug>(coc-snippets-select)
	
	" Use <C-j> for jump to next placeholder, it's default of coc.nvim
	let g:coc_snippet_next = '<c-j>'
	"
	" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
	let g:coc_snippet_prev = '<c-k>'
	"
	" Use <C-j> for both expand and jump make expand higher priority.)(
	imap <C-j> <Plug>(coc-snippets-expand-jump)
endfunc
