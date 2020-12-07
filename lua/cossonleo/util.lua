M = {}

function M.current_file_size()
	local size = vim.fn.getfsize(vim.fn.expand('%'))
	if size <= 0 then
		return ""
	end

	if size < 1024 then
		return tostring(size) .. 'B'
	elseif size < 1024*1024 then
		return string.format('%.1f', size/1024.0) .. 'K'
	elseif size < 1024*1024*1024 then
		return string.format('%.1f', size/1024.0/1024.0) .. 'M'
	else
		return string.format('%.1f', size/1024.0/1024.0/1024.0) .. 'G'
	end

	return ""
end

function M.grep_dir()
	local default = vim.fn.expand('<cword>')
	vim.api.nvim_command("echohl PromHl")
	vim.fn.inputsave()
	local input = vim.fn.input({prompt = 'rg> ', default = default, highlight = 'GrepHl'})
	vim.fn.inputrestore()
	vim.api.nvim_command("echohl None")

	--if #input == 0 then input = default end
	if #input == 0 then
		vim.cmd[[echo "no input for grep"]]
		return 
	end
	require("easyfind").grep(input)
end


function M.file_name_limit(len)
	local path = vim.fn.expand('%:p')
	local plen = #path
	if plen <= len then return path end
	local elems = {}
	local start = 2
	repeat
		local pos = path:find("/", start)
		if not pos then break end
		table.insert(elems, path:sub(start, start))
		plen = plen - (pos - start - 1)
		start = pos + 1
	until(plen <= len)
	table.insert(elems, path:sub(start))
	local new = table.concat(elems, "/")
	return "/" .. new
end

return M
