local server = {}

function server.hello()
	local s = os.execute("ls")
	print(s)
end

local afads = 1


return server
