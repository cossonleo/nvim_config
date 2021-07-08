local get_text = nvim.get_node_text1;

local context_name = {}

context_name.function_declaration = function(node, buf)
	return get_text(node:child(1)) .. '(...)', 4
end

context_name.method_declaration = function(node, buf)
	local nc1 = node:child(1)
	local nc2 = node:child(2)
	return  get_text(nc1) .. ' ' .. get_text(nc2), 5
end

context_name.type_declaration = function(node)
	local temp = node:child(1)
	if temp then temp = temp:child(0) end
	if not temp then return '', 0 end
	return 'type ' .. get_text(temp), 1
end

return {
	context_name = context_name,
}
