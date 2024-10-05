-- normalize tabulation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Hybrid line numbering
vim.wo.number = true
vim.wo.relativenumber = true

-- enable highlight groups (enable 24-bit colour)
vim.opt.termguicolors = true

-- auto-format file on wirte
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- yank to system clipboard
vim.cmd [[set clipboard+=unnamedplus]]

-- plugin manager pckr
require('plugins')

-- colorscheme
require('dracula').setup {
    -- use transparent background
    transparent_bg = true, -- default false
}

vim.cmd [[colorscheme dracula]]

-- fuzzy finder
local telescopeConfig = require('telescope.config')

-- search in hidden files and directories
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
table.insert(vimgrep_arguments, '--hidden')
table.insert(vimgrep_arguments, '--glob')
table.insert(vimgrep_arguments, '!**/.git/*')

require('telescope').setup {
    defaults = {
        -- `hidden = true` is not supported in text grep commands.
        vimgrep_arguments = vimgrep_arguments,
    },
    pickers = {
        find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
        },
    },
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- indentation guides
require('ibl').setup {}

-- TreeSitter - highlighting
require('treesitter').setup {
    ensure_installed = { 'rust', 'python', 'cpp', 'lua', 'vim', 'vimdoc', 'c_sharp', 'hlsl', 'kotlin' },
}

require('lsp-conf').setup {
    ensure_installed = { 'rust_analyzer', 'pyright', 'lua_ls', 'omnisharp_mono', 'kotlin_language_server' }
}

require('cmp-conf')

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
