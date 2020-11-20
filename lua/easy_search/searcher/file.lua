local file_item = {
	name = "",
	win = 0,
}

function file_item:tips()
	return ""
end

function file_item:data_for_match()
	return self.name
end

function file_item:do_item()
	vim.cmd(":edit " .. self.name)
end

function file_item:new(name, win)
	local item = {name = name, win = win}
	setmetatable(item, {__index = self})
	return item
end

return {
	search = function() 
		local win = vim.api.nvim_get_current_win()
		local pwd = vim.fn.getcwd(-1, 0)
		local vec = require("easy_search/utils").scan_dir_rec(pwd) 
		local items = {}
		for _, p in ipairs(vec) do
			local sub = p:sub(#pwd + 2)
			local item = file_item:new(sub, win)
			table.insert(items, item)
		end
		require("easy_search/ui").new(items)
	end
}
