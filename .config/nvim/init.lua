-- Neovim を IDE 相当で使うためのエントリポイント
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.lazy')
