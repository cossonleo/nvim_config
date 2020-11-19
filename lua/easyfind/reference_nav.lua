local M = {}

local ref_item = {
	filename = "",
	lnum = 0,
	col = 0,
	text = "",
}

function ref_item:tips()
	return self.filename .. ":" .. self.lnum .. " "
end

function ref_item:data_for_match()
	return self.text
end

function ref_item:do_item()
	-- todo 查找现有的buf,以及现有的win
	vim.cmd(":edit " .. self.filename)
	local win_id = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_cursor(win_id, {self.lnum, self.col - 1})
end

function ref_item:new(item)
	setmetatable(item, {__index = self})
	return item
end

function M.reference()
	local params = vim.lsp.util.make_position_params()
	params.context = {
		includeDeclaration = true;
	}
	params[vim.type_idx] = vim.types.dictionary

	return vim.lsp.buf_request(0, 'textDocument/references', params, function(_, _, result)
		if not result then return end
		local qf_items = vim.lsp.util.locations_to_items(result)
		if #qf_items == 0 then return end
		local items = {}
		for _, qi in ipairs(qf_items) do
			local item = ref_item:new(qi)
			table.insert(items, item)
		end
		require("easyfind/ui").new(items)
	end)
end

return M
