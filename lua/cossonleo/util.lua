
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

function M.statusline()
	local cquery = queries.get_query(vim.bo.filetype, 'locals')
	if not cquery then
		print("cquery is nil" .. vim.bo.filetype)
		return ""
	end

	local current_node = nil
	local cur_line = nil

	local search = function()
		local cur_start, _, _ = current_node:start()
		for pattern, match in cquery:iter_matches(current_node, 0, current_node:start(), current_node:end_()) do
			for id, node in pairs(match) do
				local node_start, _, _ = node:start()
				if node_start > cur_start then
					return nil
				end

				local name = cquery.captures[id] -- name of the capture in the query
				if name and (name == "definition.function" or name == "definition.method") then
					return ts_utils.get_node_text(node, 0)[1] or ""
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
