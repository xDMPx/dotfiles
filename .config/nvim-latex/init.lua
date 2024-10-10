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
    ensure_installed = {}
}

-- theming and styling
require('theming-conf')

-- fuzzy finder
require('telescope-conf')

--- Language servers
require('lsp-conf').setup {
    ensure_installed = {}
}

--- Completion engine
require('cmp-conf')

require('git-conf')
