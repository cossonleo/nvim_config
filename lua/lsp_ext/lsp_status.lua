local M = {}

local function ensure_init(messages, id, name)
	if not messages[id] then
		messages[id] = { name = name, messages = {}, progress = {}, status = {} }
	end
end

local clients = {}
local messages = {}

-- Unregister stopped clients
local function unregister_client(id)
	messages[id] = nil
	clients[id] = nil
end

local function progress_callback(_, _, msg, client_id)
	if vim.fn.mode() ~= "n" then return end

	ensure_init(messages, client_id, client_id)
	local val = msg.value
	if val.kind then
		if val.kind == 'begin' then
			messages[client_id].progress[msg.token] = {
				title = val.title,
				message = val.message,
				percentage = val.percentage,
				spinner = 1
			}
		elseif val.kind == 'report' then
			messages[client_id].progress[msg.token].message = val.message
			messages[client_id].progress[msg.token].percentage = val.percentage
			messages[client_id].progress[msg.token].spinner =
			messages[client_id].progress[msg.token].spinner + 1
		elseif val.kind == 'end' then
			if messages[client_id].progress[msg.token] == nil then
				vim.api.nvim_command('echohl WarningMsg')
				vim.api.nvim_command(
					'echom "[lsp-status] Received `end` message with no corresponding `begin` from	'
						.. clients[client_id] .. '!"')
				vim.api.nvim_command('echohl None')
			else
				messages[client_id].progress[msg.token].message = val.message
				messages[client_id].progress[msg.token].done = true
				messages[client_id].progress[msg.token].spinner = nil
			end
		end
	else
		table.insert(messages[client_id], {content = val, show_once = true, shown = 0})
	end

	--vim.api.nvim_command('doautocmd User LspMessageUpdate')
end

-- Client registration for messages
local function register_client(id, name)
	ensure_init(messages, id, name)
	clients[id] = name
end

-- Process messages
function M.get_messages()
	if vim.fn.mode() ~= "n" then return {} end

	local new_messages = {}
	local msg_remove = {}
	local progress_remove = {}
	for client, data in pairs(messages) do
		if vim.lsp.client_is_stopped(client) then
			unregister_client(client)
		else
			for token, ctx in pairs(data.progress) do
				table.insert(new_messages, {
					name = data.name,
					title = ctx.title,
					message = ctx.message,
					percentage = ctx.percentage,
					progress = true,
					spinner = ctx.spinner
				})

				if ctx.done then table.insert(progress_remove, {client = client, token = token}) end
			end

			for i, msg in ipairs(data.messages) do
				if msg.show_once then
					msg.shown = msg.shown + 1
					if msg.shown > 1 then table.insert(msg_remove, {client = client, idx = i}) end
				end

				table.insert(new_messages, {name = data.name, content = msg.content})
			end

			if next(data.status) ~= nil then
				table.insert(new_messages, {
					name = data.name,
					content = data.status.content,
					uri = data.status.uri,
					status = true
				})
			end
		end
	end

	for _, item in ipairs(msg_remove) do table.remove(messages[item.client].messages, item.idx) end

	for _, item in ipairs(progress_remove) do messages[item.client].progress[item.token] = nil end

	return new_messages
end


function M.on_attach(client)
	register_client(client.id, client.name)
	--vim.g.has_lsp_status = true

	vim.cmd[[augroup lsp_aucmds]]
	vim.cmd[[au! * <buffer>]]
	--vim.api.nvim_command('au User LspDiagnosticsChanged redrawstatus!')
	vim.cmd[[au User LspMessageUpdate redrawstatus!]]
	--vim.api.nvim_command('au User LspStatusUpdate redrawstatus!')
	vim.cmd[[augroup END]]
end

vim.lsp.handlers['$/progress'] = progress_callback

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		-- Enable underline, use default values
		underline = false,
		-- Enable virtual text, override spacing to 4
		virtual_text = {
			spacing = 4,
		},
		-- Use a function to dynamically turn signs off
		-- and on, using buffer local variables
		--signs = function(bufnr, client_id)
		--	return vim.bo[bufnr].show_signs == false
		--end,
		-- Disable a feature
		update_in_insert = false,
	}
)

M.clients = clients
return M
