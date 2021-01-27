local config = require'cossonleo.plug_config'
local vim_plug = require'cossonleo.vim_plug'
local use = vim_plug.use

use 'kshenoy/vim-signature'
use 'terryma/vim-multiple-cursors'
--use 'cossonleo/neo-comment.nvim'
use 'psliwka/vim-smoothie'
use 'tpope/vim-surround'
use 'jiangmiao/auto-pairs'
------ use 'chrisbra/csv.vim'
use 'kyazdani42/nvim-web-devicons'
--use 'nvim-lua/popup.nvim'
--use 'nvim-lua/plenary.nvim'
use 'whiteinge/diffconflicts'
use 'cossonleo/dirdiff.nvim'
--use { 'luochen1990/rainbow', config = config.rainbow }
--use { 'joshdick/onedark.vim', config = config.onedark }
use {'overcache/NeoSolarized', config = config.solarized}
use { 'voldikss/vim-floaterm', config = config.vim_floaterm }
--use { 'norcalli/nvim-colorizer.lua', config = config.nvim_colorizer }
use { 'voldikss/vim-translator', config = config.vim_translator }
use { 'nvim-treesitter/nvim-treesitter', config = config.nvim_treesitter }
--use 'p00f/nvim-ts-rainbow'
use { 'neovim/nvim-lspconfig', config = config.nvim_lsp }
-- use { 'kyazdani42/nvim-tree.lua', config = config.nvim_tree }

vim_plug.load()
