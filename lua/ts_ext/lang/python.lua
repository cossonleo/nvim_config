local get_text = nvim.get_node_text1;
local context_name = {}

context_name.class_definition = function(node, buf)
	return get_text(node:child(1)), node:child_count() - 1
end

context_name.function_definition = function(node, buf)
	local suffix = ""
	if node:child(2):child_count() <= 2 then
		suffix = "()"
	else
		suffix = "(...)"
	end
	return get_text(node:child(1)) .. suffix, node:child_count() - 1
end

return {context_name = context_name}
