
local lspconfig = require'lspconfig'

lspconfig.gopls.setup{
	cmd = {"gopls", "serve"},
	settings = {
		gopls = { 
			usePlaceholders = true
		} 
	}
}

lspconfig.rust_analyzer.setup{
	["rust-analyzer"] = {},
}

lspconfig.pyls.setup{}

lspconfig.clangd.setup{}

