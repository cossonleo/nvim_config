local util = require'vim.lsp.util'
--local vfn = vim.fn

local M = {}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.window = capabilities.window or {}
capabilities.window.workDoneProgress = true

local lstatus = require("cossonleo.lsp_status")
M.default_config = {
	capabilities = capabilities,
	on_attach = function(client)
		local has_d, d = pcall(require, 'diagnostic')
		if has_d then d.on_attach(client) end
		lstatus.on_attach(client)
	end,
}

return M

-- M.references = function()
-- 	local params = util.make_position_params()
-- 	params.context = {
-- 		includeDeclaration = true;
-- 	}
-- 	params[vim.type_idx] = vim.types.dictionary
-- 
-- 	return vim.lsp.buf_request(0, 'textDocument/references', params, function(_, _, result)
-- 		if not result then return end
-- 		vim.lsp.util.set_qflist(util.locations_to_items(result))
-- 		vim.api.nvim_command("LeaderfQuickFix")
-- 		-- local wvv = vim.fn.winsaveview()
-- 		-- vim.api.nvim_command("copen")
-- 		-- vim.api.nvim_command("wincmd p")
-- 		-- vim.fn.winrestview(wvv)
-- 	end)
-- end
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
