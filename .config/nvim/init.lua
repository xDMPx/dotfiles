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
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- indentation guides
require("ibl").setup {}

-- TreeSitter - highlighting
require('nvim-treesitter.configs').setup {
    -- A list of parser names, or "all"
    ensure_installed = { "rust", "python", "cpp", "lua", "vim", "vimdoc" },
    -- List of parsers to ignore installing (or "all")
    -- ignore_install = { "javascript" },
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = false,
    -- Indentation based on treesitter for the = operator
    indent = { enable = true },

    highlight = {
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable = { "c", "rust" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
}

-- git decorations, integration for buffers
require('gitsigns').setup {}

-- git interface 
require('neogit').setup{
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
