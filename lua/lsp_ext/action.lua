local buf = 0

vim.lsp.handlers['textDocument/codeAction'] = function(_, _, actions)
  if actions == nil or vim.tbl_isempty(actions) then
    print("No code actions available")
    return
  end

  local option_strings = {"Code Actions:"}
  local width = 40
  for i, action in ipairs(actions) do
    local title = action.title:gsub('\r\n', '\\r\\n')
    title = title:gsub('\n', '\\n')
	local str = string.format("%d. %s", i, title)
    table.insert(option_strings, str)
	if width < #str then width = #str end
  end

  if buf == 0 then buf = vim.api.nvim_create_buf(false, true) end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, option_strings)

  local win = nvim.new_win_by_cursor(width, #option_strings, {buf = buf})
  vim.defer_fn(function()
      local c = vim.fn.getchar() 
      vim.api.nvim_win_close(win, true)
      if c < 48 or c > 57 then return end

      c = vim.fn.nr2char(c)
      local choice = tonumber(c)
      if choice < 1 or choice > #actions then
    	return
      end
      local action_chosen = actions[choice]
      -- textDocument/codeAction can return either Command[] or CodeAction[].
      -- If it is a CodeAction, it can have either an edit, a command or both.
      -- Edits should be executed first
      if action_chosen.edit or type(action_chosen.command) == "table" then
    	if action_chosen.edit then
    	  vim.lsp.util.apply_workspace_edit(action_chosen.edit)
    	end
    	if type(action_chosen.command) == "table" then
    	  vim.lsp.buf.execute_command(action_chosen.command)
    	end
      else
    	vim.lsp.buf.execute_command(action_chosen)
      end
  end, 0)
end
