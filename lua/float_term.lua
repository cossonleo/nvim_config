
local float_term = nil

function toggle_float_term()
	if float_term then 
		float_term:toggle() 
		return
	end
	float_term = require'float_term.ui'.new()
end

vim.cmd[[nnoremap <silent> <F4> :lua toggle_float_term()<cr>]]
vim.cmd[[tnoremap <silent> <F4> <c-\><c-N>:lua toggle_float_term()<cr>]]


--:tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'


