local get_node_text = require'nvim-treesitter.ts_utils'.get_node_text;

local context_name = {}

context_name.class_declaration = function(node, buf)
	local text = table.concat(get_node_text(node:child(1), buf), ' ')
	return 'class ' .. text, 2
end

context_name.enum_declaration = function(node, buf)
	local text = table.concat(get_node_text(node:child(1), buf), ' ')
	return 'enum ' .. text, 2
end

context_name.method_declaration = function(node, buf)
	local text = table.concat(get_node_text(node:child(1), buf), ' ')
	return text .. '(...)', 2
end

return {
	context_name = context_name,
}


--(record_declaration
--  name: (identifier) @definition.type)
