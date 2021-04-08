local M = {}

--variable_declarator
--parameters
--loop_expression
--function
--local_function
--local_variable_declaration
--if_statement
--for_in_statement
--repeat_statement
--while_statement
--do_statement
local function get_node_define_text(node)
	local t = node:type()
	if t == "do_statement" then return nil, true end
	if t == "repeat_statement" then return nil, true end
	if t == "if_statement" then return nil, true end
	if t == "for_in_statement" then return nil, true end
	if t == "loop_expression" then return nil, true end
	if t == "local_function" then return "", true end
	if t == "function" then return "", true end
	return nil
end

local function walk_node(node, completions)
	local define = get_node_define_text(node)
	if define then table.insert(competions, define) end

	local cur_line, cur_col, _ = node:start()
	if is_scope_node(node) then
		local end_line, end_col, _ = node:end_()
		if end_line < cur_line or
			(end_line == cur_line and end_col < cur_col)
		then return end

		local child_count = node:named_child_count()
		for i = 1, child_count do
			local child_i = node:named_child(i)
			local child_line, child_col, _ = child_i:start()
			if child_line > cur_line or
				(child_line == cur_line and child_col > cur_col)
			then break end

			walk_node(child_i, completions)
		end
	end
end

return M
