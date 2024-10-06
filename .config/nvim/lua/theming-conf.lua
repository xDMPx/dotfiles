-- Hybrid line numbering
vim.wo.number = true
vim.wo.relativenumber = true

-- enable highlight groups (enable 24-bit colour)
vim.opt.termguicolors = true

-- colorscheme
require('dracula').setup {
    -- use transparent background
    transparent_bg = true, -- default false
}

vim.cmd [[colorscheme dracula]]

-- LSP floating windows round borders
-- https://vi.stackexchange.com/questions/39074/user-borders-around-lsp-floating-windows
local _border = 'rounded'

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = _border
    }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = _border
    }
)

vim.diagnostic.config {
    float = {
        border = _border
    }
}

require('lspconfig.ui.windows').default_options = {
    border = _border
}

-- Transparent LSP, etc. windows
-- https://vi.stackexchange.com/questions/38038/how-to-change-background-color-of-the-text-of-hover-window
local set_hl_for_floating_window = function()
    vim.api.nvim_set_hl(0, 'NormalFloat', {
        link = 'Normal',
    })
    vim.api.nvim_set_hl(0, 'FloatBorder', {
        bg = 'none',
    })
end

set_hl_for_floating_window()

vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    desc = 'Avoid overwritten by loading color schemes later',
    callback = set_hl_for_floating_window,
})

-- transparent bg and dracula colors for Neogit
vim.cmd [[hi NeogitDiffAdd guifg=#50FA7B guibg=#00000000]]
vim.cmd [[hi NeogitDiffHeader cterm=bold gui=bold guifg=#8BE9FD guibg=#00000000]]
vim.cmd [[hi NeogitDiffDelete guifg=#d15a5a guibg=#00000000]]
vim.cmd [[hi NeogitHunkHeader cterm=bold gui=bold guifg=#8BE9FD guibg=#00000000]]
vim.cmd [[hi NeogitDiffContextHighlight guibg=#00000000]]
vim.cmd [[hi NeogitDiffContext guibg=#00000000]]
vim.cmd [[hi NeogitCursorLine guibg=#00000000]]
vim.cmd [[hi NeogitDiffAddHighlight guifg=#50FA7B guibg=#00000000]]
vim.cmd [[hi NeogitDiffContextHighlight guibg=#00000000]]
vim.cmd [[hi NeogitDiffDeleteHighlight guifg=#ff6e6e guibg=#00000000]]
vim.cmd [[hi NeogitHunkHeaderHighlight gui=bold guifg=#8BE9FD guibg=#00000000]]
