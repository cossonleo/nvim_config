
local M = {}

function M.context_check(node, ft)
	local context_types = require("ts_ext.lang." .. ft).context_types
	for t in ipairs(context_types) do
		if t.name == node:type() then
			return t.show(node)
		end
	end
	return "", 0
end

return M
