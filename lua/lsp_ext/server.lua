
require'lspconfig'.gopls.setup{
	gopls = { usePlaceholders = true, completeUnimported = true },
}

require'lspconfig'.rust_analyzer.setup{
	["rust-analyzer"] = {},
}

require'lspconfig'.pyls.setup{}

require'lspconfig'.clangd.setup{}

