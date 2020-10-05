
local a = vim.api
local M

local pbuf = 0
local mbuf = 0
local list_data = {}
local cur_item = 0

M.item = {
	line_show = function(buf, line, match) end
	preview = function(buf) end
	do = function() end
}

local function create_mbuf()
	if mbuf ~= 0 then return end
	mbuf = a.nvim_create_buf(false, false)
	-- set hotkey
end

local function reset_mbuf()

end

local function show()
	reset_mbuf()
	cur_item = 1
	local line = 2
	for _, item in ipairs(list_data) do
		if item.line_show(mbuf, line, "") then
			line + 1
		end
	end

	-- disyplay mwin

	if list_data[cur_item].preview(pbuf) then
		--  display preview
	end
end

function M.show(data)
	if type(data) ~= "table" then return end
	if #data == 0 then return end
	list_data = data
	show()
end


return M
