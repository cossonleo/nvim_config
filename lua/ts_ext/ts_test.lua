local queries = require'vim.treesitter.query'
--local ts_locals = require'nvim-treesitter.locals'
--local parsers = require'nvim-treesitter.parsers'
local ts_utils = require'nvim-treesitter.ts_utils'
local a = vim.api

local function get_root_node()
    local parser = vim.treesitter.get_parser(bufnr, lang)
	if not parser then return nil end
    local tstree = parser:parse()
	if not tstree then return nil end
	return tstree:copy()
end


get_root_node()
