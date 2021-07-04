local get_node_text = require'nvim-treesitter.ts_utils'.get_node_text;

local func = {
	name = "function_declaration",
	show = function(node, buf)
		return get_node_text(node:child(1), buf), 4
	end
}

local method = {
	name = "method_declaration",
	show = function(node)
		local nc1 = node:child(1)
		local nc2 = node:child(2)
		return get_node_text(nc1, buf) .. " " .. get_node_text(nc2, buf), 5
	end
}

local type = {
	name = "type_declaration",
	show = function(node)
		return get_node_text(node:child(1), buf), 1
	end
}

return {
	context_types = {func, method, type},
}
