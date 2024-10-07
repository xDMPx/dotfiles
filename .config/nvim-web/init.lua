-- normalize tabulation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- auto-format file on wirte
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- yank to system clipboard
vim.cmd [[set clipboard+=unnamedplus]]

-- plugin manager pckr
require('plugins')

-- theming and styling
require('theming-conf')

-- fuzzy finder
require('telescope-conf')

-- TreeSitter - highlighting
require('treesitter-conf').setup {
    ensure_installed = { 'lua', 'vim', 'vimdoc', 'javascript', 'typescript', 'html', 'css', 'vue' },
}

require('lsp-conf').setup {
    ensure_installed = { 'lua_ls', 'ts_ls', 'html', 'cssls', 'volar' }
}

require('cmp-conf')

require('git-conf')
