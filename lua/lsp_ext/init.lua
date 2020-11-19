local util = require'vim.lsp.util'
--local vfn = vim.fn

local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
--capabilities.window = capabilities.window or {}
--capabilities.window.workDoneProgress = true

-- local lstatus = require("lsp_ext.lsp_status")
M.default_config = {
	capabilities = capabilities,
	on_attach = function(client)
		local has_d, d = pcall(require, 'diagnostic')
		if has_d then d.on_attach(client) end
		--lstatus.on_attach(client)
	end,
}

return M

-- 
-- M.document_symbol = function()
-- 	local params = { textDocument = util.make_text_document_params() }
-- 	return vim.lsp.buf_request(0, 'textDocument/documentSymbol', params, function(_, _, result, _, bufnr)
-- 		if not result or vim.tbl_isempty(result) then return end
-- 		util.set_qflist(util.symbols_to_items(result, bufnr))
-- 		vim.api.nvim_command("LeaderfQuickFix")
-- 	end)
-- end
-- 
-- M.workspace_symbol = function(query)
-- 	-- query = query or npcall(vfn.input, "Query: ")
-- 	query = query or vfn.input("Query: ")
-- 	local params = {query = query}
-- 	return vim.lsp.buf_request(0, 'workspace/symbol', params, function(_, _, result, _, bufnr)
-- 		if not result or vim.tbl_isempty(result) then return end
-- 		util.set_qflist(util.symbols_to_items(result, bufnr))
-- 		vim.api.nvim_command("LeaderfQuickFix")
-- 	end)
-- end
