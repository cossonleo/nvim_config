
local lspconfig = require'lspconfig'
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.contextSupport = true

local config = {
	capabilities = capabilities,
	settings = {
		gopls = { 
			usePlaceholders = true
		},
		["rust-analyzer"] = {},
	}
}

lspconfig.gopls.setup(config)

lspconfig.rust_analyzer.setup(config)

lspconfig.pyls.setup(config)

lspconfig.clangd.setup(config)

