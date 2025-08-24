return {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'williamboman/mason.nvim',
  },
  config = function()
    require('mason').setup()

    require('mason-lspconfig').setup {
      ensure_installed = { -- defining a server here register in lsp-config automatically
        'lua_ls',
        'ts_ls',
        'qmlls',
      },
      automatic_installation = true,
    }
  end,
}
