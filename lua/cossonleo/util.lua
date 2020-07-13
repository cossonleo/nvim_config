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

return M
