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


-- package manager for LSP servers, DAP servers, linters, and formatters 
require('mason').setup {}
require('mason-lspconfig').setup {
  ensure_installed = { "rust_analyzer", "pyright", "lua_ls" }
}

-- CMP(completion engine) configuration 
local cmp = require('cmp')
cmp.setup{
snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' },
    })
}
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- LSP configuration
local lspconfig = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig['rust_analyzer'].setup {
    capabilities = capabilitie
}
lspconfig['pyright'].setup {
    capabilities = capabilitie
}
lspconfig['lua_ls'].setup {
    capabilities = capabilitie
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

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
