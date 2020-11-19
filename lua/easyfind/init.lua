
local M = {}

function M.files()
	require("easyfind/file_nav").scan_dir()
end

function M.grep(word)
	require("easyfind/grep_nav").grep(word)
end

function M.buf_list()
	require("easyfind/buf_nav").buf_list()
end

function M.reference()
	require("easyfind/reference_nav").reference()
end

return M

