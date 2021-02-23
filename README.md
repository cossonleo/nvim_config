# nvim_config

## 安装

`cd ~/.config && git clone https://github.com/cossonleo/nvim_config.git nvim && nvim -c "PlugInstall"`

## 特性
+ lsp 补全
+ lsp 提供的代码导航
+ easy motion 和 quick scope
+ 文件 buffer symbols reference grep 等等导航
+ statusline： lsp诊断信息 lsp progress信息 当前函数或结构体符号信息 文件大小等等信息
+ 两个目录文件差异比对

## 等待开发的特性
+ 增加treesitter补全支持
+ marks导航
暂时这么多吧

## 直接使用其他工程代码
+ vim-plug: 实现外部插件管理功能
+ 模糊匹配算法来自 github.com/prabirshrestha/asyncomplete.vim

## 外部插件
+ kshenoy/vim-signature
+ terryma/vim-multiple-cursors
+ psliwka/vim-smoothie
+ tpope/vim-surround
+ jiangmiao/auto-pairs
+ kyazdani42/nvim-web-devicons
+ whiteinge/diffconflicts
+ overcache/NeoSolarized
+ voldikss/vim-floaterm
+ voldikss/vim-translator
+ nvim-treesitter/nvim-treesitter
+ neovim/nvim-lspconfig

## 快捷键与命令
+ 外部插件 lua/plugins.lua
+ 自有功能 `init.lua lua/init.lua lua/*/init.lua`

## 代码结构
TODO

## 说明
此配置目标开箱即用， 不提供灵活的配置， 如果需要定制， fork此配置， 自行更改相关代码或配置， 也欢迎提pr
