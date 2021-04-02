
local searcher = {}
local init = nvim_eutil.call_once(function ()
	searcher.file = require("easy_search.searcher.file")
	searcher.grep = require("easy_search.searcher.grep")
	searcher.buf = require("easy_search.searcher.buf")
	searcher.reference = require("easy_search.searcher.reference")
	searcher.term = require("easy_search.searcher.term")
	searcher.symbols = require("easy_search.searcher.symbols")
	searcher.vim_menu = require("easy_search.searcher.vim_menu")
	searcher.marks = require("easy_search.searcher.marks")
	searcher.history = require("easy_search.searcher.history")
	searcher.resume = { search = function() require("easy_search.ui").re_open() end }
end)

function easy_search_launch(src)
	init()
	searcher[src].search(searcher.history.add)
end

local function bind_key(key, searcher)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>" .. key,
		string.format(":lua easy_search_launch('%s')<cr>", searcher),
		{silent = true}
	)
end

bind_key("<leader>", "file")
bind_key("b", "buf")
bind_key("h", "history")
bind_key("g", "grep")
bind_key("r", "reference")
bind_key("s", "symbols")
bind_key("t", "term")
bind_key("v", "vim_menu")
bind_key("z", "resume")

vim.cmd "hi! link EasysearchSearch Function"
vim.cmd "hi! link EasysearchSelect Error"
vim.cmd "hi! link EasysearchNormal CursorLine"
