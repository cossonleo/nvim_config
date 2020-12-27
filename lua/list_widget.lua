
local view_data = {
	data = {},
	first_row = 0, -- 0-based
	row_len = 0,
}

function view_data:new(data, row_len)
	local o = {
		data = data,
		frist_row = 0,
		row_len = row_len,
	}

	setmetatable(o, {__index = self})
	return o
end

function view_data:view()
	local rows = {}
	local len = self.row_len
	if #self.data < len then 
		len = #self.data 
	end 
	for i = 1, len do
		table.insert(rows, self.data[self.first_row + i])
	end
	return rows
end

function view_data:scroll_down()
	if self.first_row + self.row_len < #self.data then
		self.first_row = self.first_row + 1
		return true
	end
	return false
end

function view_data:scroll_up()
	if self.first_row > 0 then
		self.first_row = self.first_row - 1
		return true
	end
	return false
end

local view_buf = {
	buf_id = 0,
	select = 0, -- 0-based
}

local view = {
	buf_id = 0,
	data = {},
	first = 0,
	cur = 0,
}
