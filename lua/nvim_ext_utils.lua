local M = {}

function M.call_once(f)
	local called = false
	local ret = nil 
	return function()
		if called then 
			if ret then
				return unpack(ret)
			else
				return nil
			end
		end

		called = true
		local temp = { f() }
		if #temp == 0 or #temp[1] == nil then
			return
		end
		ret = temp
		return unpack(ret)
	end
end

return M
