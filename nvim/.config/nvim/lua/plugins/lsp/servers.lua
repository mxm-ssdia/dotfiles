return {
  'neovim/nvim-lspconfig',
  dependencies = { 'saghen/blink.cmp' },
  config = function()
    local lspconfig = require 'lspconfig'
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    -- Import your on_attach for buff from lsp.lua
    local on_attach = require('plugins.lsp.lsp').on_attach

    lspconfig.lua_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = { Lua = { completion = { callSnippet = 'Replace' } } },
    }

    lspconfig.ts_ls.setup { capabilities = capabilities, on_attach = on_attach }
    lspconfig.qmlls.setup { capabilities = capabilities, on_attach = on_attach, cmd = { 'qmlls' } }
    lspconfig.nil_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = { 'nil' }, -- make sure "nil" is in your PATH
      settings = {
        ['nil'] = {
          formatting = {
            command = { 'nixpkgs-fmt' }, -- optional: choose nix formatter
          },
        },
      },
    }
  end,
}
