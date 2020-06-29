-- 延迟加载

local M = {}

function M.grep_dir()
	local default = vim.fn.expand('<cword>')
	vim.api.nvim_command("echohl PromHl")
	vim.fn.inputsave()
	local input = vim.fn.input({prompt = 'rg> ', default = default, highlight = 'GrepHl'})
	vim.fn.inputrestore()
	vim.api.nvim_command("echohl None")

	if #input == 0 then
	    return
	end
	vim.api.nvim_command('Leaderf rg ' .. input)
end

return M
