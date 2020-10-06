M = {}

function M.current_file_size()
	local size = vim.fn.getfsize(vim.fn.expand('%'))
	if size <= 0 then
		return ""
	end

	if size < 1024 then
		return tostring(size) .. 'B'
	elseif size < 1024*1024 then
		return string.format('%.1f', size/1024.0) .. 'K'
	elseif size < 1024*1024*1024 then
		return string.format('%.1f', size/1024.0/1024.0) .. 'M'
	else
		return string.format('%.1f', size/1024.0/1024.0/1024.0) .. 'G'
	end

	return ""
end


function M.grep_dir()
	local has_tl, _ = pcall(require, 'telescope')
	if not has_tl then
		print("not installed telescope")
		return
	end
	local default = vim.fn.expand('<cword>')
	vim.api.nvim_command("echohl PromHl")
	vim.fn.inputsave()
	local input = vim.fn.input({prompt = 'rg> ', highlight = 'GrepHl'})
	vim.fn.inputrestore()
	vim.api.nvim_command("echohl None")

	local opt = nil
	if #input > 0 then
		opt = { search = input }
	end
	require'telescope.builtin'.grep_string(opt)
end

local spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' }
function M.lsp_info()
	local stl = {}
	if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
		return ""
	end
	local ec = vim.lsp.util.buf_diagnostics_count([[Error]])
	if ec and ec > 0 then table.insert(stl, "E:" .. ec) end
	local wc = vim.lsp.util.buf_diagnostics_count([[Warning]])
	if wc and wc > 0 then table.insert(stl, "W:" .. wc) end

	local buf_messages = require'cossonleo.lsp_status'.get_messages()
	local msgs = {}
	for _, msg in ipairs(buf_messages) do
		local name = msg.name
		local client_name = '[' .. name .. ']'
		local contents = ''
		if msg.progress then
			contents = msg.title
			if msg.message then
				contents = contents .. ' ' .. msg.message
			end

			if msg.percentage then
				contents = contents .. ' (' .. msg.percentage .. ')'
			end

			if msg.spinner then
				contents = spinner_frames[(msg.spinner % #spinner_frames) + 1] .. ' ' .. contents
			end
		elseif msg.status then
			contents = msg.content
			if msg.uri then
				local filename = vim.uri_to_fname(msg.uri)
				filename = vim.fn.fnamemodify(filename, ':~:.')
				local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
				if #filename > space then
					filename = vim.fn.pathshorten(filename)
				end

				contents = '(' .. filename .. ') ' .. contents
			end
		else
			contents = msg.content
		end

		table.insert(msgs, client_name .. ' ' .. contents)
	end
	return vim.trim(table.concat(msgs, ' ') .. ' ' .. table.concat(stl, " "))
end

function M.lsp_info_old()
	local has_ls, ls = pcall(require, 'lsp-status')
	if not has_ls then return "" end

  if #vim.lsp.buf_get_clients() == 0 then
    return ''
  end

  local buf_diagnostics = ls.diagnostics()
  local buf_messages = ls.messages()
  local only_hint = true
  local some_diagnostics = false
  local status_parts = {}
  if buf_diagnostics.errors and buf_diagnostics.errors > 0 then
    table.insert(status_parts, 'E' .. ' ' .. buf_diagnostics.errors)
    only_hint = false
    some_diagnostics = true
  end

  if buf_diagnostics.warnings and buf_diagnostics.warnings > 0 then
    table.insert(status_parts, 'W' .. ' ' .. buf_diagnostics.warnings)
    only_hint = false
    some_diagnostics = true
  end

  if buf_diagnostics.info and buf_diagnostics.info > 0 then
    table.insert(status_parts, 'I' .. ' ' .. buf_diagnostics.info)
    only_hint = false
    some_diagnostics = true
  end

  if buf_diagnostics.hints and buf_diagnostics.hints > 0 then
    table.insert(status_parts, 'H' .. ' ' .. buf_diagnostics.hints)
    some_diagnostics = true
  end

  local msgs = {}
  for _, msg in ipairs(buf_messages) do
    local name = msg.name
    local client_name = '[' .. name .. ']'
    local contents = ''
    if msg.progress then
      contents = msg.title
      if msg.message then
        contents = contents .. ' ' .. msg.message
      end

      if msg.percentage then
        contents = contents .. ' (' .. msg.percentage .. ')'
      end

      if msg.spinner then
        contents = spinner_frames[(msg.spinner % #spinner_frames) + 1] .. ' ' .. contents
      end
    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ':~:.')
        local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)))
        if #filename > space then
          filename = vim.fn.pathshorten(filename)
        end

        contents = '(' .. filename .. ') ' .. contents
      end
    else
      contents = msg.content
    end

    table.insert(msgs, client_name .. ' ' .. contents)
  end

  return vim.trim(table.concat(status_parts, ' ') .. ' ' .. table.concat(msgs, ' '))
end

function M.file_name_limit(len)
	local path = vim.fn.expand('%:p')
	local plen = #path
	if plen <= len then return path end
	local elems = {}
	local start = 2
	repeat
		local pos = path:find("/", start)
		if not pos then break end
		table.insert(elems, path:sub(start, start))
		plen = plen - (pos - start - 1)
		start = pos + 1
	until(plen <= len)
	table.insert(elems, path:sub(start))
	local new = table.concat(elems, "/")
	return "/" .. new
end

return M
