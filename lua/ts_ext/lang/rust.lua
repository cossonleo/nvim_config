local get_node_text = require'nvim-treesitter.ts_utils'.get_node_text;

local context_name = {}

context_name.function_item  = function(node, buf)
--(function_item 
--  name: (identifier) @definition.method
--  parameters: (parameters 
--                (self_parameter)))
	local text = table.concat(get_node_text(node:child(1), buf), ' ')
	return text .. '(...)', 2
end

context_name.struct_item = function(node, buf)
	local text = table.concat(get_node_text(node:child(1), buf), ' ')
	return 'struct ' .. text, 2
end

context_name.enum_item = function(node, buf)
	local text = table.concat(get_node_text(node:child(1), buf), ' ')
	return 'enum ' .. text, 2
end

context_name.macro_definition = function(node, buf)
	local text = table.concat(get_node_text(node:child(1), buf), ' ')
	return text .. '!', 2
end

context_name.mod_item  = function(node, buf)
	local text = table.concat(get_node_text(node:child(1), buf), ' ')
	return 'mod ' .. text, 2
end

-- TODO
context_name.impl_item = function(node, buf)
	return 'impl ', 1
end

return {
	context_name = context_name,
}
