local api = require("completor.api")
local snippet = require("completor.snippet")
local log = require("completor.log")

local M = {}

local mark_ns = vim.api.nvim_create_namespace('completor_ns')
local cursor_extmark = 0

-- line: 0-based
local function get_indent(line)
	local num = vim.fn.indent(line + 1)
	local c = ' '
	if vim.bo.expandtab then
		local sw = vim.fn.shiftwidth()
		num = num / sw 
		c = '\t'
	end

	local indent = ''
	for i = 1, num do
		indent = c .. indent
	end
	return indent
end

local function set_extmark(mark_id, head, tail)
	local opt = {}
	if mark_id > 0 then
		opt.id = mark_id
	end
	if tail and #tail == 2 then
		opt.end_line = tail[1]
		opt.end_col = tail[2]
		opt.hl_group = "SnippetHl"
	end
	return vim.api.nvim_buf_set_extmark( 0, mark_ns, head[1], head[2], opt)
end

local function convert_mark_info(mark)
	if not mark or #mark == 0 then return nil end
	local info = {id = mark[1], range = {{mark[2], mark[3]}}}
	local m4 = mark[4]
	if m4 and m4.end_col and m4.end_col > info.range[1][2] then
		table.insert(info.range, {m4.end_row, m4.end_col})
	end
	return info
end

local function get_next_extmark()
	local marks = vim.api.nvim_buf_get_extmarks(
		0,
		mark_ns,
		api.cur_pos(),
		{-1, -1},
		{details = true, limit = 1}
	)

	if not marks or #marks == 0 then return nil end
	return convert_mark_info(marks[1])
end

local function get_extmark(id)
	local mark = vim.api.nvim_buf_get_extmark_by_id(
		0,
		mark_ns,
		id,
		{ details = true }
	)

	if not mark or #mark == 0 then return nil end
	table.insert(mark, 1, id)
	return convert_mark_info(mark)
end

local function set_cursor_by_extmark(info)
	local range = info.range
	api.set_cursor(range[1])
	if #range == 2 and api.pos_relation(range[1], range[2]) == -1 then
		vim.api.nvim_buf_set_text(
			0,
			range[1][1],
			range[1][2],
			range[2][1],
			range[2][2],
			{}
		)
	end
	vim.api.nvim_buf_del_extmark(0, mark_ns, info.id)
end

local function sort_by_key(fn)
	return function(a,b)
		local ka, kb = fn(a), fn(b)
		assert(#ka == #kb)
		for i = 1, #ka do
			if ka[i] ~= kb[i] then
				return ka[i] < kb[i]
			end
		end
		-- every value must have been equal here, which means it's not less than.
		return false
	end
end

local edit_sort_key = sort_by_key(function(e)
	return {e.head[1], e.head[2], e.i}
end)

-- edit: { new_text = {line1, line2}, head = { line, col } , tail = {line, col} }
local function apply_edit(ctx, edit, create_mark)
	local new_marks = {}
	for i, text in ipairs(edit.new_text) do
		local placeholders, new_str = snippet.parse(text)
		edit.new_text[i] = new_str or text
		local offset = 0
		if i == 1 then
			offset = edit.head[2]
		end
		if create_mark then
			local line = edit.head[1] + i - 1
			for _, ph in ipairs(placeholders) do
				table.insert(new_marks, {line, offset + ph[1], offset + ph[2]})
			end
		end
	end

	vim.api.nvim_buf_set_text(
		0,
		edit.head[1],
		edit.head[2],
		edit.tail[1],
		edit.tail[2],
		edit.new_text
	)

	local cursor_mark = nil
	local last_pos = nil
	for _, ph in ipairs(new_marks) do
		local mid = set_extmark(0, ph, {ph[1], ph[3]})
		if not last_pos or api.pos_relation(last_pos, ph) == 1 then
			last_pos = {ph[1], ph[2]}
			cursor_mark = mid
		end
	end

	return cursor_mark
end

local function apply_complete_edits(user_data, on_select)
	local bufnr = 0
	local ctx = user_data.ctx
	local text_edits = user_data.text_edits

	local ctx_line = ctx.pos[1]
	local ctx_col = ctx.pos[2]
	local ctx_typed = ctx.typed
	local ctx_marks = ctx.marks

	if not next(text_edits) then return end

	local edit_on_select = function(e)
		head = {e.range.start.line; e.range.start.character};
		tail = {e.range["end"].line; e.range["end"].character};
		local new_text = e.newText

		if head[1] ~= ctx_line and tail[1] ~= ctx_line then return nil end
		if head[1] < ctx_line then
			local temp = vim.split(e.newText, '\n', true);
			new_text = temp[#temp]
			head = {ctx_line, 0}
		elseif tail[1] > ctx_line then
			local temp = vim.split(e.newText, '\n', true);
			new_text = temp[1]
			tail = {ctx_line + 1, 0}
		else
			new_text = vim.fn.substitute(new_text, "\\n", "\\\\n", 'g');
		end

		return {
			head = head;
			tail = tail;
			new_text = {new_text}
		}
	end

	local edit_on_done = function(e)
		head = {e.range.start.line; e.range.start.character};
		tail = {e.range["end"].line; e.range["end"].character};
		local new_text =  vim.split(e.newText, '\n', true);
		if #new_text > 1 and user_data.insertTextMode == 2 then
			local indent = get_indent(head[1])
			for i = 2, #new_text do
				new_text[i] = indent .. new_text[i]
			end
		end

		return {
			head = head,
			tail = tail,
			new_text = new_text
		}
	end

	local cleaned = {}
	for i, e in ipairs(text_edits) do
		-- local edit = get_edit(e)
		local edit = nil
		if on_select then
			edit = edit_on_select(e)
		else
			edit = edit_on_done(e)
		end

		if edit then
			edit.i = i
			table.insert(cleaned, edit)
		end
	end

	table.sort(cleaned, edit_sort_key)

	local cursor_mark = nil
	for i = #cleaned, 1, -1 do
		cursor_mark = apply_edit(ctx, cleaned[i], not on_select) or cursor_mark
	end
	return cursor_mark
end

function M.restore_ctx(ctx)
	local ctx_line = ctx.pos[1]
	api.set_lines(ctx_line, ctx_line + 1, {ctx.typed})
	for _, m in ipairs(ctx.marks) do
		set_extmark(m.id, m.range[1], m.range[2])
	end

	--  设置或恢复cursor_extmark
	cursor_extmark  = set_extmark(cursor_extmark, {ctx.pos[1], ctx.pos[2]})
	vim.api.nvim_win_set_cursor(0, {ctx.pos[1] + 1, ctx.pos[2]})
end

function M.apply_complete_user_data(data, on_select)
	if not data.text_edits or #data.text_edits == 0 then
		return
	end
	log.trace("apply complete user data")
	if type(data) ~= "table" or vim.tbl_isempty(data) then
		return
	end
	
	M.restore_ctx(data.ctx)

	local cursor_mark = apply_complete_edits(data, on_select) or cursor_extmark
	if cursor_mark == 0 then return end
	local info = get_extmark(cursor_mark)
	if info then set_cursor_by_extmark(info) end
	if cursor_mark ~= cursor_extmark then
		vim.api.nvim_buf_del_extmark(0, mark_ns, cursor_extmark)
	end
end

function M.jump_to_next_pos()
	local info = get_next_extmark()
	if info == nil then return end
	set_cursor_by_extmark(info)
end


-- 应该保存所有namespace的extmarks
function M.get_line_marks(line)
	local ext_marks = vim.api.nvim_buf_get_extmarks(
		0,
		mark_ns,
		{line, 0},
		{line, -1},
		{details = true}
	)

	local marks = {}
	for _, m in ipairs(ext_marks) do
		local info = convert_mark_info(m)
		if info then table.insert(marks, info) end
	end
	return marks
end

return M

