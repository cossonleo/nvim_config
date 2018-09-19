
if exists("s:is_loaded")
	finish
endif
let s:is_loaded = 1

func git_plug#add_git_plug()
	Plug 'airblade/vim-gitgutter'
	Plug 'tpope/vim-fugitive'
	Plug 'tpope/vim-git'
	Plug 'gregsexton/gitv'
endfunc
