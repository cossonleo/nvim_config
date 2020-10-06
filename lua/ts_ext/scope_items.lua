local actions = require('telescope.actions')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local utils = require('telescope.utils')

local conf = require('telescope.config').values

local filter = vim.tbl_filter
local flatten = vim.tbl_flatten

local M = {}

local function prepare_func_match(entry, kind)
  local entries = {}

  if entry.node then
	  if kind == "function" or 
		  kind == "method" or 
		  kind == "type" or 
		  kind == "macro" or 
		  kind == "namespace" 
	  then
		  entry["kind"] = kind
		  table.insert(entries, entry)
	  end
  else
    for name, item in pairs(entry) do
        vim.list_extend(entries, prepare_func_match(item, name))
    end
  end

  return entries
end

M.list_scope_item = function(opts)
  opts = opts or {}

  opts.show_line = utils.get_default(opts.show_line, true)

  local has_nvim_treesitter, _ = pcall(require, 'nvim-treesitter')
  if not has_nvim_treesitter then
    print('You need to install nvim-treesitter')
    return
  end

  local parsers = require('nvim-treesitter.parsers')
  if not parsers.has_parser() then
    print('No parser for the current buffer')
    return
  end

  local ts_locals = require('nvim-treesitter.locals')
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

  local results = {}
  for _, definitions in ipairs(ts_locals.get_definitions(bufnr)) do
    local entries = prepare_func_match(definitions)
    for _, entry in ipairs(entries) do
      table.insert(results, entry)
    end
  end

  if vim.tbl_isempty(results) then
    return
  end

  pickers.new(opts, {
    prompt    = 'Treesitter Symbols',
    finder    = finders.new_table {
      results = results,
      entry_maker = make_entry.gen_from_treesitter(opts)
    },
    previewer = previewers.vim_buffer.new(opts),
    sorter    = sorters.get_generic_fuzzy_sorter(),
  }):find()
end

return M
