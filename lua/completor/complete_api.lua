local M = {}
local complete_items = {}
local last_ctx = nil
local context = require("completor.context")
local head_fuzzy_match = require("completor.fuzzy_match").head_fuzzy_match

function M.filter_items(ctx)
	local fc = ctx or context.new()
	local typed = fc:typed_to_cursor()
	local filter = typed:match("[%w_]*$")
	local items = head_fuzzy_match(complete_items, filter)
	if #items > 0 then
		vim.fn.complete(last_ctx.pos[2] + 1, items)
	end
	return #items
end

function M.nvim_complete(ctx, items)
	if last_ctx and last_ctx.changedtick > ctx.changedtick then
		return
	end

	if not last_ctx or last_ctx.changedtick < ctx.changedtick then
		complete_items = {}
		last_ctx = context.new(ctx)
	end
	complete_items = vim.list_extend(complete_items, items)
	M.filter_items()
end

return M
