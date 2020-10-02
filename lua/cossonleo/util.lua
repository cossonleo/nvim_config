
local queries = require'nvim-treesitter.query'
--local parser = vim.treesitter.get_parser(0, "rust")
--local tstree = parser:parse()
--local root = tstree:root()
local ts_utils = require 'nvim-treesitter.ts_utils'

M = {}

M.update_current_file_size = function()
		local size = vim.fn.getfsize(vim.fn.expand('%'))
	if size <= 0 then
		vim.b.current_file_size = ''
		return
	end

		if size < 1024 then
				vim.b.current_file_size = tostring(size) .. 'B'
		elseif size < 1024*1024 then
				vim.b.current_file_size = string.format('%.1f', size/1024.0) .. 'K'
		elseif size < 1024*1024*1024 then
				vim.b.current_file_size = string.format('%.1f', size/1024.0/1024.0) .. 'M'
		else
				vim.b.current_file_size = string.format('%.1f', size/1024.0/1024.0/1024.0) .. 'G'
		end

end

local cquery = nil
local ft = ""

function M.statusline()
	local cur_ft = vim.bo.filetype
	if ft ~=  cur_ft then
		ft = cur_ft
		cquery = queries.get_query(ft, 'locals')
	end
	if not cquery then
		return ""
	end

	local current_node = nil
	local cur_line = nil

	local check_match = function(name)
		if not name then
			return nil
		end
		if name == "definition.function" then
			return "F"
		end
		if name == "definition.method" then
			return "F"
		end
		if name == "definition.type" then
			return "T"
		end
		if name == "definition.macro" then
			return "M"
		end
		if name == "definition.namespace" then
			return "N"
		end
		return nil
	end

	local search = function()
		local cur_start, _, _ = current_node:start()
		for pattern, match in cquery:iter_matches(current_node, 0, current_node:start(), current_node:end_()) do
			for id, node in pairs(match) do
				local node_start, _, _ = node:start()
				if node_start > cur_start then
					return nil
				end

				local t = check_match(cquery.captures[id]) -- name of the capture in the query
				if t then
					local text = ts_utils.get_node_text(node, 0)[1] or ""
					return t .. ":" .. text
				end
			end
		end
		return nil
	end

	repeat 
		if current_node then
			current_node = current_node:parent()
		else
			current_node = ts_utils.get_node_at_cursor()
		end
		if not current_node then return "" end
		local ret = search()
		if ret then
			return ret
		end
	until(false)
end

return M
