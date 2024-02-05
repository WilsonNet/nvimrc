-- This file can be loaded by calling `lua require('plugins')` from your init.vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {'folke/tokyonight.nvim'},
  { "rose-pine/neovim", name = "rose-pine" },
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  'theprimeagen/harpoon',
  'mbbill/undotree',
  'tpope/vim-fugitive',
  "github/copilot.vim",
  "jose-elias-alvarez/null-ls.nvim",
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},
  -- LSP Support
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
    }
  },
  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {'L3MON4D3/LuaSnip'}
    },
  },
})



  vim.opt.termguicolors = true
  vim.cmd.colorscheme('tokyonight')
