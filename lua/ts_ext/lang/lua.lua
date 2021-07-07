local get_node_text = require'nvim-treesitter.ts_utils'.get_node_text;

local context_name = {}

context_name.function_declaration = function(node, buf)
	local text = table.concat(get_node_text(node:child(1), buf), ' ')
	return 'func ' .. text, 4
end

context_name.method_declaration = function(node, buf)
	local nc1 = node:child(1)
	local nc2 = node:child(2)
	local text1 = table.concat(get_node_text(nc1, buf), ' ')
	local text2 = table.concat(get_node_text(nc2, buf), ' ')
	return  text1 .. ' ' .. text2, 5
end

context_name.type_declaration = function(node)
	local temp = node:child(1)
	if temp then temp = temp:child(0) end
	if not temp then return '', 0 end
	local text = table.concat(get_node_text(temp, buf), ' ')
	return 'type ' .. text, 1
end

return {
	context_name = context_name,
}
