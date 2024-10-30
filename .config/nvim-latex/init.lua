-- normalize tabulation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- auto-format file on wirte
vim.cmd [[
  autocmd BufWritePre * lua if vim.bo.filetype ~= 'kotlin' then vim.lsp.buf.format() end
]]

-- yank to system clipboard
vim.cmd [[set clipboard+=unnamedplus]]

-- plugin manager pckr
require('plugins').setup {
    ensure_installed = {
        { 'lervag/vimtex',
            -- https://github.com/lewis6991/pckr.nvim/issues/37
            config_pre = function()
                vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/site/pack/pckr/opt/vimtex')
            end
        }
    }
}

-- VimTeX
vim.g.vimtex_view_method = 'sioyek'

-- theming and styling
require('theming-conf')

-- fuzzy finder
require('telescope-conf')

--- Language servers
require('lsp-conf').setup {
    ensure_installed = {
        'ltex',
        'texlab'
    }
}

--- Completion engine
require('cmp-conf')

require('git-conf')
