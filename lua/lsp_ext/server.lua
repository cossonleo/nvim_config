
local lspconfig = require'lspconfig'
local on_attach = require'lsp_ext.on_attach'.on_attach

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.contextSupport = true

local function config(settings)
	local config = {
		capabilities = capabilities,
		on_attach = on_attach, 
--		on_init = function(client)
--			if client.config.flags then
--				client.config.flags.allow_incremental_sync = true
--			else
--				client.config.flags = {}
--				client.config.flags.allow_incremental_sync = true
--			end
--		end,
	}
	if settings then config.settings = settings end
	return config
end

lspconfig.pyls.setup(config())

lspconfig.clangd.setup(config())

lspconfig.gopls.setup(config{
	gopls = { 
		usePlaceholders = true
	},
})

lspconfig.rust_analyzer.setup(config{
	["rust-analyzer"] = {
		cargo = {
			loadOutDirsFromCheck = false,
		},
		procMacro = {
			enable = true
		},
	},
})
