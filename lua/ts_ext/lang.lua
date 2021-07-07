
local M = {}

function M.context_check(node, ft)
	local context_name = require("ts_ext.lang." .. ft).context_name
	local get_name = context_name[node:type()]
	if get_name then
		return get_name(node, 0)
	end
	return "", 0
end

return M
