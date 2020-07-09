local M = {}

local plug_list = {
		"'Yggdroot/LeaderF', { 'do': './install.sh' }",
		"'kyazdani42/nvim-tree.lua'"
}

M.load_plug = function()
		local vim_strs = {}
		for p in ipairs(plug_list) do
			table.insert(vim_strs, "Plug " .. p)
		end
		local vim_str = table.concat(vim_strs, "\n")
end

return M
