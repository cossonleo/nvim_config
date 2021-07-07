local std_config = vim.fn.stdpath("config")
local config_fns = {}
local plug_names = {}

nvim.use_plug = function(plug)
	if type(plug) == "string" then
		table.insert(plug_names, plug)
		return
	end
	if type(plug) == "table" and plug[1] then
		table.insert(plug_names, plug[1])
		if plug.config then table.insert(config_fns, plug.config) end
	end
end

nvim.load_plugs = function()
	vim.fn['plug#begin'](std_config .. "/plugged")
	for _, plug in ipairs(plug_names) do
		local cmd = [[Plug ']] .. plug .. [[']]
		vim.cmd(cmd)
	end
	vim.fn['plug#end']()

	for _, fn in ipairs(config_fns) do
		fn()
	end
end
