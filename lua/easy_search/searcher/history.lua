
local history_item = {
	item_tips = "",
	items = {},
}

function history_item:tips()
	return ""
end

function history_item:searched_str()
	return self.item_tips
end

function history_item:do_item()
	return false, function()
		require("easy_search.ui").new(self.items)
	end
end

function history_item:new(tips, items)
	local item = {item_tips = tips, items = items}
	setmetatable(item, {__index = self})
	return item
end

local history_data = {}
local max_records = 20
return {
	search = function() 
		require("easy_search.ui").new(history_data)
	end,

	add = function(tips, item)
		table.insert(history_data, 1, history_item:new(tips, item))
		if #history_data > max_records then
			table.remove(history_data)
		end
	end
}
