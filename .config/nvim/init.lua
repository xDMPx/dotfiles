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
require('plugins').setup {
    ensure_installed = {}
}

-- theming and styling
require('theming-conf')

-- fuzzy finder
require('telescope-conf')

-- TreeSitter - highlighting
require('treesitter-conf').setup {
    ensure_installed = { 'rust', 'python', 'cpp', 'lua', 'vim', 'vimdoc', 'c_sharp', 'hlsl', 'kotlin' },
}

--- Language servers
require('lsp-conf').setup {
    ensure_installed = { 'rust_analyzer', 'pyright', 'lua_ls', 'omnisharp_mono', 'kotlin_language_server' }
}

--- Completion engine
require('cmp-conf')

require('git-conf')

vim.api.nvim_create_user_command('AndroidBuildDebug', function()
    local output = vim.fn.system { './gradlew', 'assembleDebug', '--parallel' }
    print(output)
end, {})

vim.api.nvim_create_user_command('AndroidBuildRelease', function()
    local output = vim.fn.system { './gradlew', 'build', '--parallel' }
    print(output)
end, {})

vim.api.nvim_create_user_command('AndroidInstallDebug', function()
    local output = vim.fn.system { './gradlew', 'installDebug', '--parallel' }
    print(output)
end, {})
