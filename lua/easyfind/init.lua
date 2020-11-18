
local M = {}

function M.files()
	require("easyfind/file_nav").scan_dir()
end

return M

