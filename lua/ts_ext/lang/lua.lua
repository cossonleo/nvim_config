local get_text = nvim.get_node_text1

local context_name = {}

context_name.local_function = function(node, buf)
	local c2 = node:child(2)
	if c2 == nil then return '', 0 end
	return get_text(c2), 4
end

context_name["function"] = function(node, buf)
	local c1 = node:child(1)
	if c1 == nil then return '', 0 end
	return get_text(c1), 3
end

context_name.variable_declaration = function(node, buf)
	local c2 = node:child(2)
	if c2 == nil or c2:type() ~= "function_definition" then return '', 0 end
	return get_text(node:child(0)), 3
end

context_name.local_variable_declaration = function(node, buf)
	local c3 = node:child(3)
	if c3 == nil or c3:type() ~= "function_definition" then return '', 0 end
	return get_text(node:child(1)), 4
end

return {
	context_name = context_name,
}
