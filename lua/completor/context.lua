--------------------------------------------------
--    LICENSE: 
--     Author: 
--    Version: 
-- CreateTime: 2020-03-08 16:56:35
-- LastUpdate: 2020-03-08 16:56:35
--       Desc: 
--------------------------------------------------

local text_edit = require("completor.text_edit")
local api = require("completor.api")

local _min_fire_len = 2

local _semantics_fire_pattern = {
	cpp = {"->", "::", "#", "%."},
	c = {"->", "::", "#", "%."},
	rust = {"%.", "::"},
	lua = {"%.", ":"},
	go = {"%."},
	javascript = {"%."},
	php = {"%.", "->"},
	html = {"<"},
}

-- position_param = {}
local Context = {
	changedtick = 0,
	buf = 0,
	pos = {},
	typed = "",
	marks = {},
}

-- self > ctx
-- self 相对 ctx的偏移输入
-- 若不是偏移输入则返回nil
function Context:offset_typed(ctx)
	if not self or not ctx then return nil end
	if self.buf == 0 or self.buf ~= ctx.buf then
		return nil
	end
	if self.pos[1] ~= ctx.pos[1] then return nil end
	if ctx.pos[2] > self.pos[2] then return nil end
	local front_typed = ctx:typed_to_cursor()
	if not vim.startswith(self.typed, front_typed) then
		return nil
	end
	if ctx.pos[2] == self.pos[2] then return "" end
	local offset_typed = self.typed:sub(ctx.pos[2] + 1, self.pos[2])
	local check = offset_typed:match('[%w_]+')
	if check and offset_typed == check then
		return check
	end
	return nil
end

function Context:typed_to_cursor()
	return self.typed:sub(1, self.pos[2])
end

function Context:can_fire_complete()
	local ft = vim.bo.filetype
	if ft == "" then
		return false
	end

	local typed = self.typed:sub(1, self.pos[2])
	local suffix = typed:match('[%w_]+$')
	if suffix and #suffix >= _min_fire_len then
		return true
	end

	local trigger_patterns = _semantics_fire_pattern[ft]
	if not trigger_patterns then
		return false
	end

	for _, sub in ipairs(trigger_patterns) do
		local pattern = sub .. "[%w_]*$"
		if typed:match(pattern) then
			return true
		end
	end
	return false
end

function _new(ctx)
	local new_ctx = {}
	if ctx then
		new_ctx.changedtick = ctx.changedtick
		new_ctx.buf = ctx.buf
		new_ctx.typed = ctx.typed
		new_ctx.pos = {ctx.pos[1], ctx.pos[2]}
		new_ctx.marks = {}
		-- 这里暂时赋值引用， 如果有bug, 则赋值拷贝
		new_ctx.marks = ctx.marks
		--for _, m in ipairs(ctx.marks) do
		--	table.insert(new_ctx.marks, {
		--		id = m.id,
		--		range = {
		--			{m.range[1][1], m.range[1][2]},
		--			{m.range[2][1], m.range[2][2]},
		--		}
		--	})
		--end
	else
		new_ctx.changedtick = vim.b.changedtick
		new_ctx.buf = api.cur_buf()
		new_ctx.typed = api.cur_line()
		new_ctx.pos = api.cur_pos()
		new_ctx.marks = text_edit.get_line_marks(new_ctx.pos[1])
	end
	setmetatable(new_ctx, {__index = Context})
	return new_ctx
end

return {new = _new}
