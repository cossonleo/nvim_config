local server = {}

function server.hello()
	local s = os.execute("ls")
	print(s)
end


return server
