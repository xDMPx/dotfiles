local lsp_conf = {}

lsp_conf.setup = function(config)
    -- package manager for LSP servers, DAP servers, linters, and formatters
    -- jdk17-openjdk required for kotlin_language_server to work with Android
    require('mason').setup {}
    require('mason-lspconfig').setup {
        ensure_installed = config.ensure_installed
    }

    -- LSP configuration
    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    for _, lsp in ipairs(config.ensure_installed) do
        -- Temporary fix until #468 gets merged
        if lsp == 'omnisharp_mono' then
            local configs = require('lspconfig.configs')
            configs.omnisharp_mono = require('lspconfig.configs.omnisharp')
        end
        if lsp == 'ts_ls' then
            -- requires extra/vue-typescript-plugin
            lspconfig[lsp].setup {
                capabilities = capabilities,
                filetypes = { 'typescript', 'javascript', 'vue' },
                init_options = {
                    plugins = {
                        {
                            name = '@vue/typescript-plugin',
                            location = '/usr/lib/node_modules/@vue/typescript-plugin',
                            languages = { 'javascript', 'typescript', 'vue' },
                        },
                    },
                }
            }
        else
            lspconfig[lsp].setup {
                capabilities = capabilities
            }
        end
    end
end


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

return lsp_conf