local get_node_text = require'nvim-treesitter.ts_utils'.get_node_text;

local func = {
	name = "function_declaration",
	show = function(node, buf)
		return get_node_text(node:child(1), buf)
	end
}

local method = {
	name = "method_declaration",
	show = function(node)
		local node1 = node:child(1):child(1):child(1):child(1)
		if not node1 then node1 = node:child(1):child(1):child(1) end
		return get_node_text(node1, buf) .. "::" .. get_node_text(node:child(2), buf)
	end
}

local type = {
	name = "type_declaration",
	show = function(node)
		return get_node_text(node:child(1):child(0), buf)
	end
}

return {
	context = {func, method, type},
}
