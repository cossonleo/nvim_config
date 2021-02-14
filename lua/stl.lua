local function get_util()
	return require'cossonleo.util'
end

function stl_ts()
	return get_util().ts_stl()
end

function stl_file_size()
	vim.b.cur_fsize = get_util().current_file_size()
end

function stl_lsp_info()
	return require("lsp_ext").statusline()
end

function stl_file_name(len)
	local len = len or 50
	vim.b.fit_len_fname = get_util().file_name_limit(len)
end
