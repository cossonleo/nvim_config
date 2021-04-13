
local lspconfig = require'lspconfig'
local on_attach = require'lsp_ext.on_attach'.on_attach

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.contextSupport = true

local function config(settings)
	local config = {
	}
	if settings then config.settings = settings end
	return config
end

local config = {
	capabilities = capabilities,
	on_attach = on_attach, 
	settings = {
		gopls = { 
			usePlaceholders = true
		},
		["rust-analyzer"] = {
			cargo = {
				loadOutDirsFromCheck = false,
			},
			procMacro = {
				enable = true
			},
		},
	},
--	on_init = function(client)
--		if client.config.flags then
--			client.config.flags.allow_incremental_sync = true
--		else
--			client.config.flags = {}
--			client.config.flags.allow_incremental_sync = true
--		end
--	end,
}

local server_list = { "pyls", "clangd", "gopls", "rust_analyzer"}

for _, serv in ipairs(server_list) do
	lspconfig[serv].setup(config)
end

lspconfig.pyls.setup(config)

lspconfig.clangd.setup(config)

lspconfig.gopls.setup(config)

lspconfig.rust_analyzer.setup(config)
