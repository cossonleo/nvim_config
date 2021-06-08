
local lspconfig = require'lspconfig'

local function capabilities()
	local abilities = vim.lsp.protocol.make_client_capabilities()
	abilities.textDocument.completion.completionItem.snippetSupport = false
	abilities.textDocument.completion.contextSupport = true
	return abilities
end

local handle_config = nvim.util.call_once(function()
	require'lsp_ext.action'
	require'lsp_ext.rename'

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		vim.lsp.handlers.hover, {
			border = "single" 
		}
	)
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
		vim.lsp.handlers.signature_help, {
			border = "single"
		}
	)
end)

local function on_attach(client, bufnr)		
	handle_config()
	local opts = { noremap=true, silent=true }		
	local function nnoremap(lhs, rhs) vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, opts) end		
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.		
	nnoremap('<c-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>')		
	nnoremap('gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>')		
	nnoremap('gD', '<cmd>lua vim.lsp.buf.implementation()<CR>')		
	nnoremap('K', '<Cmd>lua vim.lsp.buf.hover({border = "single"})<CR>')		
	nnoremap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')		
	nnoremap('gr', '<cmd>lua nvim.lsp.rename()<CR>')		
	nnoremap('gf', '<cmd>lua vim.lsp.buf.code_action()<CR>')		
	nnoremap('[e', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')		
	nnoremap(']e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')		

	-- Set some keybinds conditional on server capabilities		
	if client.resolved_capabilities.document_formatting then		
		nnoremap("gq", "<cmd>lua vim.lsp.buf.formatting()<CR>")		
	elseif client.resolved_capabilities.document_range_formatting then		
		nnoremap("gq", "<cmd>lua vim.lsp.buf.range_formatting()<CR>")		
	end		

	--nnoremap('<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')		
	--nnoremap('<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')		
	--nnoremap('<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')		
	--nnoremap('<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')		
	--nnoremap('<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')		

	-- Set autocommands conditional on server_capabilities		
--	if client.resolved_capabilities.document_highlight then		
--	vim.api.nvim_exec([[		
--		hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow		
--		hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow		
--		hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow		
--		augroup lsp_document_highlight		
--		autocmd! * <buffer>		
--		autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()		
--		autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()		
--		augroup END		
--	]], false)		
--	end		
end

local config = {
	capabilities = capabilities(),
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

for _, serv in ipairs(nvim.lsp.servers or {}) do
	lspconfig[serv].setup(config)
end

require'lspinstall'.setup() -- important
local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup(config)
end
