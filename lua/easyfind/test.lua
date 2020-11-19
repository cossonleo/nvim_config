local M = {}


local ret = "test.lua"
function other_uv(ret)
	local luv = require("luv")
	function exe(p)
		local function readFileSync(path)
			local uv = require("luv")
			local fd = assert(uv.fs_open(path, "r", 438))
			local stat = assert(uv.fs_fstat(fd))
			local data = assert(uv.fs_read(fd, stat.size, 0))
			assert(uv.fs_close(fd))
			return data
		end
		return readFileSync(p)
	end

	function cb(data)
		ret = data
	end

	local work = luv.new_work(exe, cb)
	work:queue(ret)
end

local lw = vim.loop.new_work(other_uv, function() end)
lw:queue(ret)

print(ret)

return M
