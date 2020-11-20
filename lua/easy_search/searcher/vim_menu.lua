
local menu_item = {
	desc = "",
	map_key = "",
	do_action = nil,
}

function menu_item:tips()
	return string.format("%-20s", self.map_key)
end

function menu_item:searched_str()
	return self.desc
end

function menu_item:trigger_key()
	if not self.map_key then return end

	local ty = type(self.map_key)
	if ty == "string" then
		vim.schedule(function()
			vim.api.nvim_feedkeys(self.map_key, 'n', true)
		end)
		return
	end

	if ty ~= "table" then
		return
	end

	local mode = "n"
	local key = ""
	if #self.map_key > 0 then
		key = self.map_key[1]
		mode = self.map_key[2] or mode
	else
		mode = self.map_key.mode or mode
		key = self.map_key.key
	end

	if not key or #key == 0 then return end
	vim.schedule(function() vim.api.nvim_feedkeys(key, mode, true) end)
end

function menu_item:do_item()
	if not self.do_action then 
		--self:trigger_key()
		return 
	end
	
	local ty = type(self.do_action)
	if ty == "function" then
		vim.schedule(self.do_action)
		return
	end
	if ty == "string" then
		vim.cmd(self.do_action)
		return
	end
end

function menu_item:new(desc, map_key, action)
	local item = {map_key = map_key, desc = desc, do_action = action}
	setmetatable(item, {__index = self})
	return item
end

local M = {}

function M.search()
	local items = {}
	table.insert(items, menu_item:new("buffer list", "<leader>b", require("easy_search").buf_list))
	table.insert(items, menu_item:new("file list", "<leader><leader>", require("easy_search").files))
	table.insert(items, menu_item:new("func list", "<leader>f", require("easy_search").func))
	table.insert(items, menu_item:new("floaterm toggle", "<F4>", "FloatermToggle"))
	table.insert(items, menu_item:new("floaterm new", "<leader><F4>", "FloatermNew"))
	table.insert(items, menu_item:new("floaterm next", "<S-<F4>>", "FloatermNext"))
--
--	vim.g.floaterm_keymap_toggle = '<F4>'
--	vim.g.floaterm_keymap_new    = '<leader><F4>'
--	vim.g.floaterm_keymap_next   = '<F16>'
	require("easy_search/ui").new(items)
end

return M
