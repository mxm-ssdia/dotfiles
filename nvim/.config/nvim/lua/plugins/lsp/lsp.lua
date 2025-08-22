--[[
    :help lsp-defaults - for defaults lsp keymaps
    :help diagnostic-defaults

To customize, see:
    :help lsp-attach
    :help lsp-buf
]]
--
return {
  'neovim/nvim-lspconfig', --:help lsp-quickstart for all servers
  dependencies = {
    -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
    { 'mason-org/mason.nvim', opts = {} }, --install lsp servers in nvim
    'mason-org/mason-lspconfig.nvim',      -- bridges the gap btw mason and lspconfig
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim',    opts = {} }, -- Useful status updates for LSP.
    'saghen/blink.cmp',                    -- Allows extra capabilities provided by blink.cmp
  },
  config = function()
    -- `:help lsp-vs-treesitter`

    vim.api.nvim_create_autocmd('LspAttach', { -- run when an lsp attaches to a particular buffer
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        --NORMAL VIM POWERED
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')                                                    -- Rename the variable under your cursor.
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })                       -- usually your cursor needs to be on top of an error
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')                                     -- in C this would take you to the header. not Goto Definition, this is Goto Declaration.
        map('grk', vim.lsp.buf.hover, '[G]oto [H]over')                                                 --go to hover
        --TELESCOPE POWERED
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')                  -- Find references for the word under your cursor.
        map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')         -- Jump to the implementation of the word under your cursor.
        map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')                 -- 	--  To jump back, press <C-t>.
        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')           -- Fuzzy find all the variables, functions, types,in your current document.
        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols') -- Fuzzy find all the symbols in your current workspace.searches over your entire project

        -- highlight references under cursor
        local client = vim.lsp.get_client_by_id(event.data.client_id) -- highlight start
        if client and client.supports_method 'textDocument/documentHighlight' then
          local highlight_augroup = vim.api.nvim_create_augroup('lsp-document-highlight', { clear = false })

          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            buffer = event.buf,
            group = highlight_augroup,
            callback = function()
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = highlight_augroup, buffer = event.buf }
            end,
          })
        end --ends highlight

        -- Inlay hint toggle
        if client and client.supports_method 'textDocument/inlayHint' then
          map('<leader>th', function()
            local bufnr = event.buf
            local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
            vim.lsp.inlay_hint.set { enabled = not enabled, bufnr = bufnr }
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Diagnostic Config  See :help vim.diagnostic.Opts
    -- 1. Custom diagnostic highlights
    vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = '#F38BA8' })
    vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = '#F9E2AF' })
    vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = '#89B4FA' })
    vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = '#94E2D5' })

    vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = '#F38BA8' })
    vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = '#F9E2AF' })
    vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = '#89B4FA' })
    vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = '#94E2D5' })

    -- 		-- no warning for diagonist
    -- 		-- Diagnostic configuration
    -- vim.diagnostic.config({
    --     severity_sort = true,
    --     float = {
    --         border = "rounded",
    --         source = "if_many",
    --     },
    --     underline = {
    --         severity = vim.diagnostic.severity.ERROR,
    --     },
    --     signs = {
    --         { name = "DiagnosticSignError", text = "󰅚" },
    --         { name = "DiagnosticSignWarn",  text = "󰀪" },
    --         { name = "DiagnosticSignInfo",  text = "󰋽" },
    --         { name = "DiagnosticSignHint",  text = "󰌶" },
    --     },
    --     virtual_text = {
    --         source = "if_many",
    --         spacing = 2,
    --         format = function(d)
    --             return d.message
    --         end,
    --     },
    -- })
    --
    -- Diagnostic signs with Nerd Font icons
    local signs = {
      Error = '󰅚',
      Warn = '󰀪',
      Info = '󰋽',
      Hint = '󰌶',
    }

    for name, icon in pairs(signs) do
      local hl = 'DiagnosticSign' .. name
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end

    -- Diagnostic config
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many', header = '', prefix = '' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = true, -- now we just keep this as true
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(d)
          return d.message
        end,
      },
    }

    --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Function that runs when an LSP attaches to a buffer
    local on_attach = function(client, bufnr)
      -- Example: disable formatting if you want external tools (prettier, stylua, etc.)
      if client.name == 'ts_ls' or client.name == 'lua_ls' then --stylua takes care
        client.server_capabilities.documentFormattingProvider = false
      end

      -- buffer-local keymaps attach on everry lsp buff
      -- local opts = { buffer = bufnr }

      -- ===== Optional: inlay hints (if supported) =====
      if client.supports_method 'textDocument/inlayHint' then
        vim.lsp.inlay_hint(bufnr, true)
      end
    end

    local servers = { -- server ins start
      -- clangd = {},
      -- gopls = {},
      -- pyright = {},
      -- rust_analyzer = {},
      -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
      --
      -- Some languages (like typescript) have entire language plugins that can be useful:
      --    https://github.com/pmizio/typescript-tools.nvim
      --
      -- But for many setups, the LSP (`ts_ls`) will work just fine
      ts_ls = {},
      -- QML/Qt LSP
      qmlls = {            -- <- just a table of options
        cmd = { 'qmlls' }, -- path to qmlls binary
        filetypes = { 'qml', 'js' },
        root_dir = require('lspconfig').util.root_pattern('CMakeLists.txt', '.git'),
        settings = {
          QML = {
            lint = true,
            codeModel = true,
          },
        },
      },

      lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ... },
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    } -- lsp inst end

    ---- Tools Mason should install
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })
    --Ensures that all servers you defined in servers are automatically installed.
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    --this connects Mason-installed servers with nvim-lspconfig
    require('mason-lspconfig').setup { --lsp config start
      ensure_installed = {},           -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {}) -- Merge capabilities
          server.on_attach = on_attach                                                                    -- 🔥 Attach our custom on_attach here
          require('lspconfig')[server_name].setup(server)                                                 --Useful when disablingcertain features of an LSP (for example, turning off formatting for ts_ls)
        end,
      },
    } -- lsp config end
  end,
}
