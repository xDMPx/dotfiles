-- Bootstrapping pckr, plugin manager

local function bootstrap_pckr()
  local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

  if not vim.uv.fs_stat(pckr_path) then
    vim.fn.system({
      'git',
      'clone',
      "--filter=blob:none",
      'https://github.com/lewis6991/pckr.nvim',
      pckr_path
    })
  end

  vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

-- Plugins

-- local cmd = require('pckr.loader.cmd')
-- local keys = require('pckr.loader.keys')

require('pckr').add{
    -- colorscheme
    'Mofiqul/dracula.nvim',

    -- fuzzy finder
    {'nvim-telescope/telescope.nvim', requires = {'nvim-lua/plenary.nvim'}},

    --  indentation guides
    'lukas-reineke/indent-blankline.nvim',

    -- Treesitter - highlighting
    { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },

    -- package manager for LSP servers, DAP servers, linters, and formatters 
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',

    { -- git interface 
    "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "nvim-telescope/telescope.nvim", -- optional
            "sindrets/diffview.nvim",        -- optional
        }
    },

    -- git decorations, integration for buffers
    'lewis6991/gitsigns.nvim',
}
