
if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

func git_plug#add_git_plug()
	call dein#begin('airblade/vim-gitgutter')
	call dein#begin('tpope/vim-fugitive')
	call dein#begin('tpope/vim-git')
	call dein#begin('gregsexton/gitv')
endfunc
