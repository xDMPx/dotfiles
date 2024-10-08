local treesitter = {}

treesitter.setup = function(config)
    require('nvim-treesitter.configs').setup {
        -- A list of parser names, or 'all'
        ensure_installed = config.ensure_installed,
        -- List of parsers to ignore installing (or 'all')
        -- ignore_install = { 'javascript' },
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
            -- disable = { 'c', 'rust' },

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
    }
    vim.filetype.add({ extension = { hlsl = 'hlsl' } })
end

return treesitter
