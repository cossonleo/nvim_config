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
	
function! s:grep_cmd()
	call inputsave()
	let input = input("grep > ")
	call inputrestore()
	let input = trim(input)
	if len(input) == 0
		let input = expand('<cword>')
	endif
	exe ':CocList --input=' . input . ' grep'
endfunction

func coc_plug#coc_config()
	set nobackup
	set nowritebackup
	" You will have bad experience for diagnostic messages when it's default 4000.
	set updatetime=300
	
	" don't give |ins-completion-menu| messages.
	set shortmess+=c
	
	" always show signcolumns
	set signcolumn=yes

	let g:coc_extension_root = $HOME . '/.config/nvim/coc/extensions'
	
	" Use tab for trigger completion with characters ahead and navigate.
	" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
	inoremap <silent><expr> <TAB>
	      \ pumvisible() ? "\<C-n>" :
	      \ <SID>check_back_space() ? "\<TAB>" :
	      \ coc#refresh()
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
	
	" Use <c-space> to trigger completion.
	inoremap <silent><expr> <c-o> coc#refresh()
	
	" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
	" Coc only does snippet and additional edit on confirm.
	inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
	"inoremap <expr> <space> pumvisible() ? "\<C-y>" : "\<C-g>u\<cr>\<space>"
	
	" Use `[c` and `]c` to navigate diagnostics
	nmap <silent> gk <Plug>(coc-diagnostic-prev)
	nmap <silent> gj <Plug>(coc-diagnostic-next)
	
	" Remap keys for gotos
	nmap <silent> gd <Plug>(coc-definition)
	"nmap <silent> gy <Plug>(coc-type-definition)
	"nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)
	
	" Use K to show documentation in preview window
	nnoremap <silent> K :call <SID>show_documentation()<CR>
	
	" Highlight symbol under cursor on CursorHold
	autocmd CursorHold * silent call CocActionAsync('highlight')
	
	" Remap for rename current word
	 nmap gc <Plug>(coc-rename)
	
	" Remap for format selected region
	"xmap <leader>f  <Plug>(coc-format-selected)
	"nmap <leader>f  <Plug>(coc-format-selected)
	
	augroup mygroup
	  autocmd!
	  " Setup formatexpr specified filetype(s).
	  "autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	  " Update signature help on jump placeholder
	  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end
	
	" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
	"xmap <leader>a  <Plug>(coc-codeaction-selected)
	"nmap <leader>a  <Plug>(coc-codeaction-selected)
	
	" Remap for do codeAction of current line
	"nmap <leader>ac  <Plug>(coc-codeaction)
	" Fix autofix problem of current line
	nmap gf  <Plug>(coc-fix-current)
	
	" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
	nmap <silent> <TAB> <Plug>(coc-range-select)
	xmap <silent> <TAB> <Plug>(coc-range-select)
	xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)
	
	" Use `:Format` to format current buffer
	command! -nargs=0 Format :call CocAction('format')
	nmap gq <Plug>(coc-format)
	
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
	" Do default action for next item.
	nnoremap <silent> <m-j>  :<C-u>CocNext<CR>
	" Do default action for previous item.
	nnoremap <silent> <m-k>  :<C-u>CocPrev<CR>
	" Resume latest coc list
	"nnoremap <silent> <leader>p  :<C-u>CocListResume<CR>
	"
	nnoremap <leader><leader> :CocList files<cr>

	nnoremap <leader>b :CocList buffers<cr>

	" Find symbol of current document
	nnoremap <silent> <leader>t :<C-u>CocList outline<cr>

	" Search workspace symbols
	nnoremap <silent> <leader>s :<C-u>CocList symbols<cr>

	" diagnostic
	nnoremap <silent> <leader>d :<C-u>CocList diagnostics<cr>

	" translation
	nnoremap <silent> <leader>a :<C-u>CocCommand translator.popup<cr>

	" Use <C-l> for trigger snippet expand.
	"imap <C-l> <Plug>(coc-snippets-expand)
	
	" Use <C-j> for select text for visual placeholder of snippet.
	"vmap <C-j> <Plug>(coc-snippets-select)

	" Use <C-j> for both expand and jump make expand higher priority.)(
	imap <C-j> <Plug>(coc-snippets-expand-jump)

	"command! -nargs=0 CocGrep call <SID>grep_cmd(<q-args>)
	"nnoremap <silent> <c-a> :CocGrep<cr>
	nnoremap <silent> <c-f> :call <SID>grep_cmd()<cr><c-u>

	let g:coc_enable_locationlist = 0
	autocmd User CocLocationsChange CocList --normal location

	nmap \| <Plug>(coc-cursors-operator)
	nmap <c-w> <Plug>(coc-cursors-operator)iw

	"nmap <silent> <C-c> <Plug>(coc-cursors-position)
	"nmap <silent> <C-d> <Plug>(coc-cursors-word)
	"xmap <silent> <C-d> <Plug>(coc-cursors-range)

	unmap <c-i>

endfunc
