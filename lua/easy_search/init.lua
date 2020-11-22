
local M = {}

function M.files()
	require("easy_search/searcher/file").search()
end

function M.grep()
	require("easy_search/searcher/grep").search()
end

function M.buf_list()
	require("easy_search/searcher/buf").search()
end

function M.reference()
	require("easy_search/searcher/reference").search()
end

function M.term_list()
	require("easy_search/searcher/term").search()
end

function M.func()
	require("easy_search/searcher/func").search()
end

function M.symbols()
	require("easy_search/searcher/symbols").search()
end

function M.vim_menu()
	require("easy_search/searcher/vim_menu").search()
end

function M.re_open()
	require("easy_search/ui").re_open()
end

return M

