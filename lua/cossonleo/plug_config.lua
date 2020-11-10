local M = {}


function M.rainbow()
	vim.g.rainbow_active = 1
end

function M.vim_easymotion()
	vim.g.EasyMotion_do_mapping = 0
	vim.cmd[[nnoremap <silent> / :call EasyMotion#S(-1, 0, 2)<cr>]]
	--vim.cmd[[ nnoremap / <Plug>(easymotion-sn) ]]
	--vim.cmd[[ onoremap / <Plug>(easymotion-tn) ]]
	--vim.cmd[[ nnoremap n <Plug>(easymotion-next)]]
	--vim.cmd[[ nnoremap N <Plug>(easymotion-prev]]
end
function M.onedark()
	vim.g.onedark_color_overrides = {black = {gui = "#000000", cterm = "235", cterm16 = 0}}
	pcall(vim.cmd, [[ colorscheme onedark ]])
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
	local has, c = pcall(require, 'colorizer')
	if not has then return end
	c.setup(nil, { css = true; })
end

function M.vim_translator()
	vim.g.EasyMotion_do_mapping = 0
	vim.cmd[[nnoremap <silent> <leader>a :TranslateW<CR>]]
end

function M.nvim_treesitter()
	local has, ts = pcall(require, 'nvim-treesitter.configs')
	if not has then return end
	require'ts_ext'.open_complete()
	ts.setup {
		ensure_installed = 'all', -- one of 'all', 'language', or a list of languages
		highlight = { 
			enable = true, 
			disable = {'python', 'rust'} 
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
	}
end

function M.nvim_lsp()
	require('vim.lsp.log').set_level(4)
	local has, nvim_lsp = pcall(require, 'nvim_lsp')
	if not has then return end

	local ext = require'lsp_ext'
	local add = function(ls, opt)
		local config = opt or {}
		config.on_attach = config.on_attach or ext.default_config.on_attach
		config.capabilities = config.capabilities or ext.default_config.capabilities
		nvim_lsp[ls].setup(config)
	end

	add('gopls', {settings = { gopls = { usePlaceholders = true,	completeUnimported = true } }})
	add('clangd')
	add('pyls')
	add('dockerls')
	add('vimls')
	add('tsserver')
	add('bashls')
	add('rust_analyzer', {settiings = { ["rust-analyzer"] = {} }})
	add('intelephense')
	add('jsonls', {
		settings = { json = { format = { enable = true } } }, 
	})
	--
	--add('sumneko_lua')
	--nvim_lsp.clangd.setup{callbacks = lsp_status.extensions.clangd.setup(),
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

	vim.cmd[[nnoremap <silent> ]e <cmd>NextDiagnosticCycle<cr>]]
	vim.cmd[[nnoremap <silent> [e <cmd>PrevDiagnosticCycle<cr>]]
	vim.cmd[[nnoremap <silent> <leader>d <cmd>OpenDiagnostic<cr>]]
end

function M.lsp_status()
	local has, lsp_status = pcall(require, 'lsp-status')
	if not has then return end
	lsp_status.register_progress()
	lsp_status.config{
		indicator_errors = 'E',
		indicator_warnings = 'W',
		status_symbol = '',
	}
end

--function M.nvim_tree()
--	vim.g.lua_tree_side = 'left' -- left by default
--	vim.g.lua_tree_size = 40 --30 by default
--	vim.g.lua_tree_ignore = { '.git', 'node_modules', '.cache' } --empty by default, not working on mac atm
--	vim.g.lua_tree_auto_close = 1 --0 by default, closes the tree when it's the last window
--	vim.g.lua_tree_follow = 0 --0 by default, this option will bind BufEnter to the LuaTreeFindFile command
--	-- :help LuaTreeFindFile for more info
--	vim.g.lua_tree_show_icons = {git = 1, folders = 1, files = 1 }
--	vim.g.lua_tree_tab_open = 1
--
--	vim.g.lua_tree_bindings = {
--		edit = '<CR>', edit_vsplit = '<C-v>', edit_split = '<C-x>', edit_tab = '<C-t>',
--		toggle_ignored = 'I', toggle_dotfiles = 'H', preview = '<Tab>', cd = '.',
--		create = 'a', remove = 'd', rename = 'r', refresh = 'R',
--		cut = 'x', copy = 'c', paste = 'p',
--		-- prev_git_item = '[c', next_git_item = ']c',
--	}
--	-- vim.api.nvim_set_keymap("n", "<leader>e", ":LuaTreeToggle<CR>", {noremap = true, silent = true})
--	vim.cmd[[ nnoremap <silent> <leader>e :LuaTreeToggle<CR>]]
--	vim.cmd[[ autocmd UIEnter * lua vim.g.lua_tree_auto_open = 1]]
--end

--function M.telescope()
--	local has, tconfig = pcall(require, 'telescope.config')
--	if not has then return end
--	--local config = tconfig.values
--	local actions = require('telescope.actions')
--
--	require('telescope').setup {
--		defaults = {
--			mappings = {
--				i = {
--					["<C-j>"] = actions.move_selection_next,
--					["<C-k>"] = actions.move_selection_previous,
--					["<esc>"] = actions.close,
--					["<c-n>"] = false,
--					["<c-p>"] = false,
--
--				},
--			},
--			sorting_strategy = "ascending",
--			prompt_position = "top",
--			use_less = false,
--		}
--	}
--
----	config.layout_strategy = 'vertical'
----	config.layout_strategy = 'center'
----	config.sorting_strategy = "ascending"
----	config.selection_strategy = 'reset'
----	map["<C-j>"] = actions.move_selection_next
----	map["<C-k>"] = actions.move_selection_previous
----	map["<esc>"] = actions.close
----	map["<c-n>"] = false
----	map["<c-p>"] = false
--
-- 	vim.cmd[[nnoremap <silent> <leader>b :lua require'telescope.builtin'.buffers{}<CR>]]
-- 	vim.cmd[[nnoremap <silent> <leader><leader> :lua require'telescope.builtin'.find_files{}<CR>]]
--	-- vim.cmd[[ nnoremap <silent> <leader>f :lua require'telescope.builtin'.list_func()<CR>]]
--	vim.cmd[[nnoremap <silent> <leader>r :lua require'telescope.builtin'.lsp_references()<CR>]]
--	vim.cmd[[nnoremap <silent> <leader>s :lua require'telescope.builtin'.lsp_document_symbols{}<CR>]]
--	vim.cmd[[nnoremap <silent> <leader>S :lua require'telescope.builtin'.lsp_workspace_symbols{}<CR>]]
--	vim.cmd[[nnoremap <silent> <leader>g :lua require('cossonleo.util').grep_dir()<cr>]]
--	vim.cmd[[nnoremap <silent> <leader>f :lua require('cossonleo.ts_ext').list_scope_item()<cr>]]
--end

function M.vim_clap()
	vim.g.clap_layout = {relative = 'editor', width = '67%', height = '66%', row = '16%', col = '16%'}
	vim.g.clap_popup_input_delay = 100
	vim.g.clap_popup_border = 'sharp'
	vim.g.clap_provider_grep_executable = 'rg'
	vim.g.clap_provider_grep_opts = '-H --no-heading --vimgrep --smart-case'
	vim.g.clap_provider_grep_delay = 300
	vim.cmd[[nnoremap <silent> <leader><leader> :Clap files<cr>]]
	vim.cmd[[nnoremap <silent> <leader>b :Clap buffers<cr>]]
end

return M
