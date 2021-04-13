local buf = vim.api.nvim_create_buf(false, true)
vim.fn.sign_define("lsp_rename_sign", {text = "≡", texthl = "Normal", linehl = "Normal"})
vim.fn.sign_place(0, "", "lsp_rename_sign", buf, {lnum = 1})
local win = 0

function on_lsp_rename_close_win()
	if win > 0 then
		vim.api.nvim_win_close(win, true)
		win = 0
	end
	vim.cmd "stopinsert"
end

function on_lsp_rename_request()
	local lines = vim.api.nvim_buf_get_lines(buf, 0, 1, false)
	local word = lines[1]
	on_lsp_rename_close_win()
	vim.lsp.buf.rename(word)
end

local map_opt = {silent = true}
vim.api.nvim_buf_set_keymap(buf, "i", "<cr>", "<c-o><cmd>lua on_lsp_rename_request()<cr>", map_opt)
vim.api.nvim_buf_set_keymap(buf, "i", "<esc>", "<c-o><cmd>lua on_lsp_rename_close_win()<cr>", map_opt)

function lsp_rename()
	local cur_word = vim.fn.expand('<cword>')
	win = vim.api.nvim_open_win(buf, true, {
		relative = "cursor",
		row = -3,
		col = 1,
		height = 1,
		width = 40,
		border = "single",
	})

	local wo = function(opt, value)
		vim.api.nvim_win_set_option(win, opt, value)
	end

	wo("relativenumber", false)
	wo("number", false)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {cur_word})
	vim.api.nvim_win_set_cursor(win, {1, #cur_word})
	if vim.api.nvim_get_mode().mode ~= "i" then
		vim.cmd "startinsert!"
	end
end

local function on_attach(client, bufnr)    
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end    
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end    

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')    

  -- Mappings.    
  local opts = { noremap=true, silent=true }    
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)    
  buf_set_keymap('n', '<c-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)    
  --buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)    
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover({border = "single"})<CR>', opts)    
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)    
  --buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)    
  --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)    
  --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)    
  --buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)    
  buf_set_keymap('n', 'gr', '<cmd>lua lsp_rename()<CR>', opts)    
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)    
  buf_set_keymap('n', '[e', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)    
  buf_set_keymap('n', ']e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)    

  -- Set some keybinds conditional on server capabilities    
  if client.resolved_capabilities.document_formatting then    
	buf_set_keymap("n", "gq", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)    
  elseif client.resolved_capabilities.document_range_formatting then    
	buf_set_keymap("n", "gq", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)    
  end    

  -- Set autocommands conditional on server_capabilities    
  if client.resolved_capabilities.document_highlight then    
	vim.api.nvim_exec([[    
	  hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow    
	  hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow    
	  hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow    
	  augroup lsp_document_highlight    
		autocmd! * <buffer>    
		autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()    
		autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()    
	  augroup END    
	]], false)    
  end    
end    

return {
	on_attach = on_attach,
}
