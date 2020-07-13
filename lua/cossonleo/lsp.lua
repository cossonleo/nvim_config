
local M = {}

M.references = function()
  local params = vim.lsp.util.make_position_params()
  params.context = {
    includeDeclaration = true;
  }
  params[vim.type_idx] = vim.types.dictionary

  return vim.lsp.buf_request(0, 'textDocument/references', params, function(_, _, result)
	  if not result then return end
	  vim.lsp.util.set_qflist(vim.lsp.util.locations_to_items(result))
	  local wvv = vim.fn.winsaveview()
	  vim.api.nvim_command("copen")
	  vim.api.nvim_command("wincmd p")
	  vim.fn.winrestview(wvv)
  end)
end

return M
