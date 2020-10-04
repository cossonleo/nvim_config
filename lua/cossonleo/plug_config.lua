local M = {}

local on_attch = function(client)
	local has_d, d = pcall(require, 'diagnostic')
	if has_d then d.on_attach(client) end
	local has_s, s = pcall(require, 'lsp-status')
	if has_s then s.on_attach(client) end
end

function M.rainbow()
	vim.g.rainbow_active = 1
end

function M.vim_easymotion()
	vim.g.EasyMotion_do_mapping = 0
	-- vim.cmd[[nnoremap <silent> / :call EasyMotion#S(-1, 0, 2)<cr>]]
	vim.cmd[[ nnoremap / <Plug>(easymotion-sn) ]]
	vim.cmd[[ onoremap / <Plug>(easymotion-tn) ]]
	vim.cmd[[ nnoremap n <Plug>(easymotion-next)]]
	vim.cmd[[ nnoremap N <Plug>(easymotion-prev]]
end
function M.onedark()
	vim.g.onedark_color_overrides = {black = {gui = "#000000", cterm = "235", cterm16 = 0}}
	vim.cmd[[ colorscheme onedark ]]
end
function M.vim_floaterm()
	vim.g.floaterm_winblend = 10
	vim.g.floaterm_width = 0.7
	vim.g.floaterm_height = 0.8
	vim.g.floaterm_position = 'center'
	vim.g.floaterm_keymap_toggle = '<F4>'
	vim.g.floaterm_keymap_new    = '<leader><F4>'
	vim.g.floaterm_keymap_next   = '<F16>'
	vim.g.floaterm_border_color = "#FFFFFF"
end

function M.nvim_colorizer()
	require 'colorizer'.setup(nil, { css = true; })
end

function M.vim_translator()
	vim.g.EasyMotion_do_mapping = 0
	vim.cmd[[ nnoremap <silent> <leader>a :TranslateW<CR> ]]
end

function M.nvim_treesitter()
	require'nvim-treesitter.configs'.setup {
		ensure_installed = 'all', -- one of 'all', 'language', or a list of languages
		highlight = { 
			enable = true, 
			disable = {} 
		},
		incremental_selection = {
			enable = true,
			disable = {},
			keymaps = {                       -- mappings for incremental selection (visual mappings)
			  init_selection = 'gn',         -- maps in normal mode to init the node/scope selection
			  node_incremental = "gn",       -- increment to the upper named parent
			  scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
			  node_decremental = "grm",      -- decrement to the previous node
			}
		},
		refactor = {
			highlight_definitions = { enable = false },
			highlight_current_scope = { enable = false },
			smart_rename = {
				enable = false,
				keymaps = {
					smart_rename = "grr",
				},
			},
			navigation = {
				enable = false,
				keymaps = {
					goto_definition_lsp_fallback = "gnd",
					list_definitions = "gnD",
					goto_next_usage = "]r",
					goto_previous_usage = "[r",
				},
			},
		},
		textobjects = {
			enable = true,
			select = {
				enable = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",

					-- Or you can define your own textobjects like this
					["iF"] = {
				--		python = "(function_definition) @function",
				--		cpp = "(function_definition) @function",
				--		c = "(function_definition) @function",
				--		java = "(method_declaration) @function",
					},
				},
			},	

			move = {
				enable = true,
				goto_next_start = {
					["]m"] = "@function.outer",
					-- ["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					-- ["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					-- ["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					-- ["[]"] = "@class.outer",
				},
			},
		},
	}
end

function M.nvim_lsp()
	require('vim.lsp.log').set_level(4)
	local lsp_status = require('lsp-status')
	local nvim_lsp = require('nvim_lsp')
	nvim_lsp.gopls.setup{
		on_attach=on_attach,
		settings = { gopls = { usePlaceholders = true,	completeUnimported = true } }
	}
	nvim_lsp.clangd.setup{callbacks = lsp_status.extensions.clangd.setup(),
		on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.pyls.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.dockerls.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.vimls.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.tsserver.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.bashls.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.rust_analyzer.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	-- nvim_lsp.sumneko_lua.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.intelephense.setup{on_attach=on_attach, capabilities = lsp_status.capabilities}
	nvim_lsp.jsonls.setup{
		on_attach=on_attach,
		settings = { json = { format = { enable = true } } }, 
		capabilities = lsp_status.capabilities
	}
end

function M.echodoc()
	vim.g['echodoc#enable_at_startup'] = 1
	vim.g['echodoc#type'] = "floating"
end

function M.diagnostic_nvim()
	vim.g.diagnostic_insert_delay = 1
	vim.g.diagnostic_enable_virtual_text = 1
	vim.g.space_before_virtual_text = 5
	vim.g.space_before_virtual_text = 5
	vim.g.diagnostic_enable_underline = 0

	vim.cmd[[ nnoremap <silent> ]e <cmd>NextDiagnosticCycle<cr> ]]
	vim.cmd[[ nnoremap <silent> [e <cmd>PrevDiagnosticCycle<cr> ]]
	vim.cmd[[ nnoremap <silent> <leader>d <cmd>OpenDiagnostic<cr> ]]
end

function M.lsp_status()
	local lsp_status = require('lsp-status')
	lsp_status.register_progress()
	lsp_status.config{
		indicator_errors = 'E',
		indicator_warnings = 'W',
		status_symbol = '',
	}
end

function M.nvim_tree()
	vim.g.lua_tree_side = 'left' -- left by default
	vim.g.lua_tree_size = 40 --30 by default
	vim.g.lua_tree_ignore = { '.git', 'node_modules', '.cache' } --empty by default, not working on mac atm
	vim.g.lua_tree_auto_close = 1 --0 by default, closes the tree when it's the last window
	vim.g.lua_tree_follow = 0 --0 by default, this option will bind BufEnter to the LuaTreeFindFile command
	-- :help LuaTreeFindFile for more info
	vim.g.lua_tree_show_icons = {git = 1, folders = 1, files = 1 }
	vim.g.lua_tree_tab_open = 1

	vim.g.lua_tree_bindings = {
		edit = '<CR>', edit_vsplit = '<C-v>', edit_split = '<C-x>', edit_tab = '<C-t>',
		toggle_ignored = 'I', toggle_dotfiles = 'H', preview = '<Tab>', cd = '.',
		create = 'a', remove = 'd', rename = 'r', refresh = 'R',
		cut = 'x', copy = 'c', paste = 'p',
		-- prev_git_item = '[c', next_git_item = ']c',
	}
	-- vim.api.nvim_set_keymap("n", "<leader>e", ":LuaTreeToggle<CR>", {noremap = true, silent = true})
	vim.cmd[[ nnoremap <silent> <leader>e :LuaTreeToggle<CR> ]]
	vim.cmd[[ autocmd UIEnter * lua vim.g.lua_tree_auto_open = 1 ]]
end

function M.telescope()
	local config = require'telescope.config'.values
	local map_i = config.default_mappings.i
	local actions = require('telescope.actions')

	config.layout_strategy = 'vertical'
--	config.layout_strategy = 'center'
--	config.sorting_strategy = "ascending"
	config.selection_strategy = 'reset'
	map_i["<C-j>"] = actions.move_selection_next
	map_i["<C-k>"] = actions.move_selection_previous
	map_i["<esc>"] = actions.close

 	vim.cmd[[ nnoremap <silent> <leader>b :lua require'telescope.builtin'.buffers{}<CR> ]]
 	vim.cmd[[ nnoremap <silent> <leader><leader> :lua require'telescope.builtin'.find_files{}<CR> ]]
	-- vim.cmd[[ nnoremap <silent> <leader>f :lua require'telescope.builtin'.list_func()<CR> ]]
	vim.cmd[[ nnoremap <silent> <leader>r :lua require'telescope.builtin'.lsp_references()<CR> ]]
	vim.cmd[[ nnoremap <silent> <leader>s :lua require'telescope.builtin'.lsp_document_symbols{}<CR> ]]
	vim.cmd[[ nnoremap <silent> <leader>S :lua require'telescope.builtin'.lsp_workspace_symbols{}<CR> ]]
	vim.cmd[[ nnoremap <silent> <leader>g :lua require('cossonleo.util').grep_dir()<cr> ]]
	vim.cmd[[ nnoremap <silent> <leader>f :lua require('cossonleo.ts_ext').list_scope_item()<cr> ]]
end

return M
