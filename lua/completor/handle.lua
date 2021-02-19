--------------------------------------------------
--    LICENSE: 
--     Author: 
--    Version: 
-- CreateTime: 2020-03-08 11:27:15
-- LastUpdate: 2020-03-08 11:27:15
--       Desc: 
--------------------------------------------------

local api = vim.api
local vimfn = vim.fn
local log = require('completor.log')
local context = require('completor.context')
local text_edit = require("completor.text_edit")


local last_ctx = nil
local last_changedtick = 0
local last_selected = -1
local incomplete = false

local function reset()
	last_ctx = nil
	last_selected = -1
	last_changedtick = 0
	incomplete = false
end

-- 由于self.ctx 与 ctx的col可能不一样
-- 则需要将新增item转换成当前ctx, 以达到显示正确
local function add_items_offset(items, offset)
	log.trace("convert items to self ctx")
	for _, item in pairs(items) do
		item.word = offset .. item.word
	end
end

local function text_changed()
	local cur_ctx = context.new()
	if last_changedtick == cur_ctx.changedtick then
	 	log.trace("repeat trigger text changed")
	 	return
	end

	last_changedtick = cur_ctx.changedtick
	last_selected = -1

	if not cur_ctx:can_fire_complete() then
		log.trace("ctx can not fire complete, typed: ", cur_ctx.typed)
		return
	end

	local offset = cur_ctx:offset_typed(last_ctx)
	if not offset then
		last_ctx = cur_ctx
		incomplete = false
	end
	if not incomplete and offset then return end

	log.trace("new ctx to trigger complete")

	local ctx = context.new(cur_ctx)
	require'completor.drivers'.complete(ctx, function(items, incomplete)
		log.trace("add complete items")
		if not items or #items == 0 then
			log.trace("no items to add")
			return
		end

		local offset = ctx:offset_typed(last_ctx)
		if not offset then return end

		if #offset > 0 then
			log.trace("offset ctx on add items")
			add_items_offset(items, offset)
		end

		vim.api.nvim_complete(last_ctx.pos[2] + 1, items, {})
		return
	end)
end

local function apply_completed_item(on_select)
	local complete_item = api.nvim_get_vvar('completed_item')
	if type(complete_item) ~= "table" or not complete_item.user_data then
		return
	end
	text_edit.apply_complete_user_data(complete_item.user_data, on_select)
	last_changedtick = vim.b.changedtick
end

local spec_keys = {
	["<cr>"] = vim.fn.nr2char(13),
	["<c-y>"] = vim.fn.nr2char(25),
}

local handlers = {}

handlers.TextChangedP = function()
	log.trace("text changed p")
	local complete_info = vimfn.complete_info({'pum_visible', 'selected'})
	if not complete_info.pum_visible then
		return
	end

	if complete_info.selected ~= -1 then
		apply_completed_item(true)
		last_selected = 1
		log.trace("on select item")
		return
	end

	if last_selected ~= -1 then
		last_selected = -1
		text_edit.restore_ctx(last_ctx)
		log.trace("on select item with not selected")
		return
	end
end

handlers.TextChangedI = function()
	log.trace("text changed i")
	text_changed()
end

handlers.InsertEnter = function()
	log.trace("on insert")
	local ft = api.nvim_buf_get_option(0, 'filetype')
	text_changed()
end

handlers.InsertLeave = function()
	log.trace("on insert leave")
	reset()
end

handlers.JumpNextSnippet = function()
	text_edit.jump_to_next_pos()
end

handlers.CompleteDone = function() 
	if vim.fn.pumvisible() == 0 then
		return spec_keys["<cr>"]
	end

	apply_completed_item()
	return spec_keys["<c-y>"]
end

return {
	handle = function(event)
		local h = handlers[event]
		if h then return h() end
	end
}
