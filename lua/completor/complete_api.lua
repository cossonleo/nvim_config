local M = {}
local complete_items = {}
local last_ctx = nil
local head_fuzzy_match = require("completor.fuzzy_match").head_fuzzy_match

local function get_typed_cursor()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	return line:sub(1, col)
end

function M.filter_items(typed)
	if #complete_items == 0 then return end
	local typed = typed or get_typed_cursor()
	local filter = typed:match("[%w_]*$") 
	local items = head_fuzzy_match(complete_items, filter)
	if #items > 0 then
		vim.fn.complete(last_ctx.pos[2] + 1, items)
	end
end

function M.nvim_complete(ctx, items)
	if last_ctx and last_ctx.changedtick > ctx.changedtick then
		return
	end

	if not last_ctx or last_ctx.changedtick < ctx.changedtick then
		complete_items = {}
		last_ctx = {
			changedtick = ctx.changedtick,
			pos = {ctx.pos[1], ctx.pos[2]},
		}
	end
	if #items > 0 then
		complete_items = vim.list_extend(complete_items, items)
	end
	M.filter_items()
end

function M.reset()
	last_ctx = nil
	complete_items = {}
end

return M
