
local M = {}

local ext_drivers = {}
local use_builtin = true

function M.add_drivers(driver)
	table.insert(ext_drivers, driver)
end

function M.disable_builtin()
	use_builtin = false
end

function M.complete(ctx, cb)
	for _, driver in ipairs(ext_drivers) do
		driver.compfunc(ctx)
	end

	if not use_builtin then
		return
	end

	require'completor.drivers.builtin_lsp'.compfunc(ctx, cb)
	require'completor.drivers.tree_sitter'.compfunc(ctx, cb)
end

return M
