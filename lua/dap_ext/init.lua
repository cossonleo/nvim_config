
local action_map = nvim_eutil.call_once(function()
	local dap = require'dap'
	return {
		toggle_breakpoint = dap.toggle_breakpoint,
		set_breakpoint = function()
			dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
		end,
		continue = dap.continue,
		step_over = dap.step_over,
		step_into = dap.step_into,
		step_out = dap.step_out,
	}
end)

local require_lang = {
	go = function() require'dap_ext.go' end,
}

function dap_map_action(key)
	local key_map = action_map()
	local req_ft = require_lang[vim.bo.ft]
	if req_ft then req_ft() end
	key_map[key]()
end

vim.cmd[[nnoremap <silent> gb :lua dap_map_action("toggle_breakpoint")<CR>]]
vim.cmd[[nnoremap <silent> gB :lua dap_map_action("set_breakpoint")<CR>]]
vim.cmd[[nnoremap <silent> <F5> :lua dap_map_action("continue")<CR>]]
vim.cmd[[nnoremap <silent> <F10> :lua dap_map_action("step_over")<CR>]]
vim.cmd[[nnoremap <silent> <F11> :lua dap_map_action("step_into")<CR>]]
vim.cmd[[nnoremap <silent> <F12> :lua dap_map_action("step_out")<CR>]]
