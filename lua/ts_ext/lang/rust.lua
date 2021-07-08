local get_node_text = require'nvim-treesitter.ts_utils'.get_node_text;

local context_name = {}

context_name.function_item  = function(node, buf)
	local count = 1
	local target = nil
	repeat
		target = node:child(count)
		count = count + 1
	until(target == nil or target:type() == "identifier")
	if target == nil then return '', 0 end
	local text = table.concat(get_node_text(target, buf), ' ')
	local pn = node:child(count)
	if pn == nil then return text, count end
	count = count + 1
	if pn:child_count() == 2 then
		return text .. '()', count
	end
	if pn:child(1):type() ~= "self_parameter" then
		return text .. '(...)', count
	end
	if pn:child_count() == 3 then
		return text .. '(self)', count
	else
		return text .. '(self, ...)', count
	end
end

context_name.struct_item = function(node, buf)
	local count = 1
	local target = nil
	repeat
		target = node:child(count)
		count = count + 1
	until(target == nil or target:type() == "type_identifier")
	if target == nil then return '', 0 end
	local text = table.concat(get_node_text(target, buf), ' ')
	return 'struct ' .. text, count
end

context_name.enum_item = function(node, buf)
	local count = 1
	local target = nil
	repeat
		target = node:child(count)
		count = count + 1
	until(target == nil or target:type() == "type_identifier")
	if target == nil then return '', 0 end
	local text = table.concat(get_node_text(target, buf), ' ')
	return 'enum ' .. text, count
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
	if node:child_count() == 3 then
		local text = table.concat(get_node_text(node:child(1), buf), ' ')
		return '<' .. text .. '>', 2
	end
	return 'impl ', 1
end

return {
	context_name = context_name,
}
