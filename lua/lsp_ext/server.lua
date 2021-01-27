local settings = {}

local add = function(...)
	servers = { ... }
	for _, serv in ipairs(servers) do
		require('lspconfig')[serv].setup(settings)
	end
end

settings = {
	gopls = { usePlaceholders = true, completeUnimported = true },
	["rust-analyzer"] = {},
}

add(
	'gopls', 
	'clangd',
	'pyls',
	'rust_analyzer'
)
