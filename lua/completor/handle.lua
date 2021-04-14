--------------------------------------------------
--    LICENSE: 
--     Author: 
--    Version: 
-- CreateTime: 2020-03-08 11:27:15
-- LastUpdate: 2020-03-08 11:27:15
--       Desc: 
--------------------------------------------------

local log = require('completor.log')
local context = require('completor.context')
local text_edit = require("completor.text_edit")
local complete_api = require("completor.complete_api")
local drivers = require('completor.drivers')

local last_ctx = nil
local last_complete_ctx = nil

local function reset()
	last_ctx = nil
	last_complete_ctx = nil
	complete_api.reset()
end

local function text_changed()
	local cur_ct = vim.b.changedtick
	if last_ctx and last_ctx.changedtick == cur_ct then
	 	log.trace("repeat trigger text changed")
	 	return
	end

	last_ctx = context.new(cur_ct)
	if not last_ctx:can_fire_complete() then
		return
	end

	if last_complete_ctx and last_ctx:offset_typed(last_complete_ctx) then
		complete_api.filter_items(last_ctx:typed_to_cursor())
		return
	end

	last_complete_ctx = last_ctx
	complete_api.nvim_complete(last_ctx, {})

	local ctx = context.copy(last_ctx)
	drivers.complete(ctx, function(items, is_incomplete)
		log.trace("add complete items")
		local incomplete = false
		if last_complete_ctx and
			items and #items > 0 and 
			last_complete_ctx:equal(ctx) 
		then
			complete_api.nvim_complete(ctx, items)
			incomplete =  is_incomplete
		end
		return incomplete
	end)
end

local function restore_ctx()
	text_edit.restore_ctx(last_ctx)
	last_ctx.changedtick = vim.b.changedtick
end

local function apply_completed_item(on_select)
	local complete_item = vim.api.nvim_get_vvar('completed_item')
	if type(complete_item) == "table" and complete_item.user_data then
		text_edit.apply_complete_user_data(complete_item.user_data, on_select)
	end
	last_ctx.changedtick = vim.b.changedtick
end

local handlers = {}
handlers.TextChangedP = function()
	log.trace("text changed p")
	local complete_info = vim.fn.complete_info({'pum_visible', 'selected', 'inserted'})
	if not complete_info.pum_visible then
		return
	end

	if complete_info.selected ~= -1 then
		apply_completed_item(true)
		last_ctx.last_selected = true
		log.trace("on select item")
		return
	end

	if last_ctx.last_selected then
		last_ctx.last_selected = false
		restore_ctx()
		log.trace("on select item with not selected")
		return
	end

	text_changed()
end

handlers.TextChangedI = function()
	log.trace("text changed i")
	-- last_ctx.last_selected = false
	text_changed()
end

handlers.InsertEnter = function()
	log.trace("on insert")
	text_changed()
end

handlers.InsertLeave = function()
	log.trace("on leave")
	reset()
end

handlers.BufLeave = function()
	log.trace("on leave")
	reset()
end

handlers.JumpNextSnippet = function()
	text_edit.jump_to_next_pos()
end

handlers.CompleteDone = function() 
	if vim.fn.pumvisible() == 0 then
		return nvim.keystroke["<cr>"]
	end

	apply_completed_item()
	return nvim.keystroke["<c-y>"]
end

return {
	handle = function(event)
		local h = handlers[event]
		if h then return h() end
	end
}
