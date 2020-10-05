
local a = vim.api
local M = {}

local pbuf = 0
local match_str = ""
local match_cache = {}
local list_data = {}

local main_buf = {
	id = 0,
	start = 0,
	cur = 0,
}

local config = {
	m_height = 0
	m_width = 0
	p_height = 0
	p_wdith = 0
}

M.item = {
	line = function(match) end
	preview = function(buf) end
	do = function() end
}

function main_buf.reset()
	main_buf.cur = 1
	main_buf.start = 1

	if main_buf.id ~= 0 then return end
	main_buf.id = a.nvim_create_buf(false, false)
	-- set hotkey
end

local function hi_cur_line()
end

local function match_items()
	local new_match = {}
	local check = function(item)
		local display = item:line(match_str)
		if display then
			table.insert(new_match, {item = item, display = display})
		end
	end

	if #match_cache > 0 then
		for _, cache in ipairs(match_cache) do
			check(cache.item)
		end
	else
		for _, item in ipairs(list_data) do
			check(item)
		end
	end

	match_cache = new_match
end

local function update()
	local line = 2
	local new_match = {}
	for _, item in ipairs(match_list) do
		local line_info = item:line(match_str)
		if line_info then
			table.insert(new_match, item)
		end
	end

	-- disyplay mwin

	if list_data[cur_item]:preview(pbuf) then
		--  display preview
	end
end

local function show()
	main_buf.reset()
	match_str = ""
	match_cache = {}
	match_items()
	M.update()
end

function M.show(data)
	if type(data) ~= "table" then return end
	if #data == 0 then return end
	list_data = data
	show()
end

function M.do()
end

function M.move_next()
	cur_item = cur_item + 1
	if cur_item > #match_list then cur_item = 1 end
	M.update()
end

function M.move_prev()
	if cur_item <= 1 then cur_item = #match_list end
	cur_item = cur_item - 1
	M.update()
end

return M
