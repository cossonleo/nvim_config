local log = require('completor.log')
local protocol = require('vim.lsp.protocol')
local api = require('completor.api')

local function fix_edits_col(ctx, edits)
	local new_edits = {}

	local fix = function(pos)
		local line = ctx.typed
		if pos.line ~= ctx.pos[1] then
			line = api.get_line(pos.line)
		end
		pos.character = vim.str_byteindex(line, pos.character)
		return pos
	end

	for _, e in ipairs(edits) do
		e.range.start = fix(e.range.start)
		e.range["end"] = fix(e.range["end"])
		table.insert(new_edits, e)
	end
	return new_edits
end

local function filter_items(ctx, items)
	if not items or #items == 0 then
		return {}
	end

	local new_items = items
	local prefix = ctx:typed_to_cursor()
	prefix = prefix:match("[%w_]+$")
	if prefix and #prefix > 0 then
		new_items = vim.tbl_filter(function(item)
		  local word = item.filterText or item.insertText or item.label
		  return vim.startswith(word, prefix)
		end, items)
	end

	log.trace("new items num: ", #new_items, " old items num: ", #items)
	return new_items
end

local function complete_items_lsp2vim(ctx, data)
	-- lsp range pos: zero-base
	local prefix = ctx:typed_to_cursor():match('[%w_]+$')
	local convert_item = function(complete_item)
		-- 组装user_data
		local user_data = {
			filter_text = complete_item.filterText or complete_item.label,
			ctx = ctx,
		}

		if complete_item.textEdit and complete_item.textEdit.newText then
			local raw_edits = {complete_item.textEdit}
			if complete_item.additionalTextEdits then
				vim.list_extend(raw_edits, complete_item.additionalTextEdits)
			end
			user_data.text_edits = fix_edits_col(ctx, raw_edits)
		end

		local word = complete_item.insertText or complete_item.label
		if complete_item.label == word and
			prefix and
			vim.startswith(word, prefix)
		then
			word = word:sub(#prefix + 1)
		end

		local documentation = function()
			if complete_item.documentation then
				if type(complete_item.documentation) == 'string' then
					return complete_item.documentation
				elseif type(complete_item.documentation) == 'table' and
					type(complete_item.documentation.value) == 'string' then
					return complete_item.documentation.value
				end
			end
			return ' ' 
		end

		local info = documentation()
		if #info == 0 then
			info = ' '
		end

		return {
			word = word,
			abbr = complete_item.label,
			kind = protocol.CompletionItemKind[complete_item.kind] or '',
			menu = complete_item.detail or '',
			info = info,
			icase = 1,
			dup = 1,
			empty = 1,
			user_data = user_data,
		}
	end

	local filter = function(item)
		if not prefix or #prefix == 0 then return true end
		return vim.startswith(item.filterText or item.label, prefix)
	end

	local items = {}
	for _, v in pairs(data) do
		if filter(v) then
			local item = convert_item(v)
			if item ~= nil then
				table.insert(items, item)
			end
		end
	end
	return items
end


local function request(ctx, complete_cb)
	if not ctx then
		return
	end
	local bufno = vim.api.nvim_get_current_buf()
	log.trace("builtin_lsp complete request")
	params = {
		textDocument = { uri = vim.uri_from_bufnr(0) },
		position = {
			line = ctx.pos[1]; 
			character = vim.str_utfindex(ctx.typed, ctx.pos[2]); 
		}
	}
	vim.lsp.buf_request(
        bufno,
        'textDocument/completion',
        params,
        function(err, _, result)
			if err or not result then
				log.warn("lsp complete err ", err)
				return
			end

			local items = result.items or result
			local incomplete = result.incomplete
			items = complete_items_lsp2vim(ctx, items)
			if items or #items > 0 then
				complete_cb(items, incomplete)
			end
        end
    )
end

return {
	compfunc = request
}
