
local function on_attach(client, bufnr)		
	require'lsp_ext.action'

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

	local opts = { noremap=true, silent=true }		
	local function nnoremap(lhs, rhs) vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, opts) end		
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.		
	nnoremap('<c-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>')		
	nnoremap('gd', '<Cmd>lua vim.lsp.buf.declaration()<CR>')		
	nnoremap('gD', '<cmd>lua vim.lsp.buf.implementation()<CR>')		
	nnoremap('K', '<Cmd>lua vim.lsp.buf.hover({border = "single"})<CR>')		
	nnoremap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')		
	nnoremap('gr', '<cmd>lua require"lsp_ext.rename".request()<CR>')		
	nnoremap('gf', '<cmd>lua require"lsp_ext.action".request()<CR>')		
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

return {
	on_attach = on_attach,
}
