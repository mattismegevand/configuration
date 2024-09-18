vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.work = vim.fn.hostname() ~= 'macbook'
vim.g.have_nerd_font = false

require 'options'
require 'keymaps'
require 'misc'
require 'lazy-bootstrap'
require 'lazy-plugins'
