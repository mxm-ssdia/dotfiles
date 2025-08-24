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
    { 'j-hui/fidget.nvim', opts = {} }, -- Useful status updates for LSP.
  },
  config = function()
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

    -- :help vim.diaggnostic.opts
    vim.diagnostic.config {
      signs = true,          -- E/W/I/H in the gutter
      virtual_text = true,   -- inline text
      underline = true,      -- squiggly underline
      update_in_insert = false,
      severity_sort = false, -- not sorted by severity
    }

    -- installing lsp servers also we get formatters wwe want to diable it
    -- as none ls takes care of that

    local on_attach = function(client, bufnr) --buff attch start
      -- Disable LSP formatting if we’re using none-ls
      if
          client.name == 'tsserver'
          or client.name == 'lua_ls'
          or client.name == 'jsonls'
          or client.name == 'html'
          or client.name == 'cssls'
      then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end

      -- Example: set keymaps for LSP
      -- local bufmap = function(mode, lhs, rhs, desc)
      --   vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      -- end
      --
      -- bufmap('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
      -- bufmap('n', 'K', vim.lsp.buf.hover, 'Hover info')
      -- bufmap('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
    end -- buff attach end
  end,
}
