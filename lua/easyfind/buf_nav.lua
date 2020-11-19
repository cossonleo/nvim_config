local M = {}


function M.buf_list()
	local list = vim.api.nvim_list_bufs()
	--bufexists()
	--bufloaded
	--buflisted({expr})
	--bufname([{expr}])
	--bufnr("$")
	--last_buffer_nr()
end

return M
