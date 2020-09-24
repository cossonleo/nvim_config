-- 延迟加载

local M = {}

function M.grep_dir()
	local default = vim.fn.expand('<cword>')
	vim.api.nvim_command("echohl PromHl")
	vim.fn.inputsave()
	local input = vim.fn.input({prompt = 'rg> ', highlight = 'GrepHl'})
	vim.fn.inputrestore()
	vim.api.nvim_command("echohl None")

	local opt = nil
	if #input > 0 then
		opt = { search = input }
	end
	require'telescope.builtin'.grep_string(opt)
end

M.add = function(plug_table)
	local plugs = {}
	for plug, _ in pairs(plug_table) do
		table.insert(plugs, 'Plug ' .. plug)
	end
	vim.api.nvim_exec(table.concat(plugs, '\n'), nil)
end

M.config = function(plug_table)
	for _, config in pairs(plug_table) do
		config()
	end
end


return M
