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

-- indentation guides
require('ibl').setup {}

-- fuzzy finder
require('telescope-conf')

-- TreeSitter - highlighting
require('treesitter').setup {
    ensure_installed = { 'rust', 'python', 'cpp', 'lua', 'vim', 'vimdoc', 'c_sharp', 'hlsl', 'kotlin' },
}

require('lsp-conf').setup {
    ensure_installed = { 'rust_analyzer', 'pyright', 'lua_ls', 'omnisharp_mono', 'kotlin_language_server' }
}

require('cmp-conf')

-- git decorations, integration for buffers
require('gitsigns').setup {}

-- git interface
require('neogit').setup {
    -- Hides the hints at the top of the status buffer
    disable_hint = true,
    -- Disables changing the buffer highlights based on where the cursor is.
    disable_context_highlighting = true,
    -- Disables signs for sections/items/hunks
    disable_signs = true,
}
