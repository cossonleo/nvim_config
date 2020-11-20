local module = {}

-- The fuzzy match is simple
module.simple_match = function(matchs, pattern)
	local result = {}
	for _, match in ipairs(matchs) do
		if vim.startswith(match, prefix) then
			table.insert(result, match)
		end
	end
	return result
end

-- 是否符合首字母模糊匹配
module.match_and_pick_sort_str = function(str, pattern)
	local slen = str:len()
	local plen = pattern:len()

	if slen < plen then return nil end
--	if str:sub(1,1) ~= pattern:sub(1,1) then
--		return nil
--	end
--
--	if plen == 1 then return {str:sub(2)} end

	local n = 1
	local sort_str = {}
	for i = 1, plen do
		if slen - n < plen - i then return nil end
		local sub_str, pc = "", pattern:sub(i, i)
		for j = n, slen, 1 do
			n = n + 1
			local sc = str:sub(j,j)
			if sc == pc then break end
			sub_str = sub_str .. sc
			if j == slen then return nil end
			if slen - j < plen - i then return nil end
		end
		table.insert(sort_str, sub_str)
	end
	table.insert(sort_str, str:sub(n))
	return sort_str
end

-- @items: table
-- @pattern:
-- return: table
module.head_fuzzy_match = function(items, pattern)

	if items == nil or #items == 0 then return {} end
	if pattern:len() == 0 then return items end

	--local lp = string.lower(pattern)
	local lp = pattern
	local sortArray = {}
	for i, v in ipairs(items) do
		-- local word = v['word']
		local word = v['abbr']
		local sort_str = module.match_and_pick_sort_str(word, lp)
		if sort_str then 
			table.insert(sortArray, {strs = sort_str, i = i})
		end
	end

	table.sort(sortArray, function(s1, s2) 
		local len = #s1.strs
		for i = 1, len, 1 do
			local ss1, ss2 = s1.strs[i], s2.strs[i]
			if #ss1 < #ss2 then return true end
			if #ss1 > #ss2 then return false end
			if ss1 < ss2 then return true end
			if ss1 > ss2 then return false end
		end
		if s1.i < s2.i then return true end
		return false
	end)

	local candicates = {}
	for _, s in ipairs(sortArray) do
		local index = s.i
		table.insert(candicates, items[index])
	end
	return candicates
end

return module
