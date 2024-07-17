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
    'Mofiqul/dracula.nvim'
}
