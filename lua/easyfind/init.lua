
local M = {}

function M.files()
	require("easyfind/file_nav").scan_dir()
end

function M.grep(word)
	require("easyfind/grep_nav").grep(word)
end

return M

