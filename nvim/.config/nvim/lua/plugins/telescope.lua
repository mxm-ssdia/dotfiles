--[[
    install ripgrep for live grep
    -treesitter dependent for a single keymap
]]
--

return {
  'nvim-telescope/telescope.nvim', --install telescope
  event = 'VimEnter',

  dependencies = {           -- dep start
    'nvim-lua/plenary.nvim', -- required u got it
    {
      -- native telescope sorter impove sorter performance
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',   -- run cmd when plugin = installled not when nvim startup
      cond = function() -- cond if plugin should be install & loaded
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },                     -- better vim.ui.select
    { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font }, -- for icons nerd font must be install
    'nvim-treesitter/nvim-treesitter',                                 -- for query / playground / fun classes etc

    'nvim-telescope/telescope-file-browser.nvim',                      -- File explorer inside telescope
    -- "nvim-telescope/telescope-project.nvim",     -- Project switching
    -- "nvim-telescope/telescope-dap.nvim",         -- Debug adapter integration

    --OPTIONAL
    --[[
        "sharkdp/fd", --(finder)
        "neovim LSP", --(picker)
        "devicons", --(icons)
        ]]
    --
  }, --dep ended

  config = function()
    -- local telescope = require("telescope") -- if u know that plugin will install as intended
    local actions = require 'telescope.actions'

    local ok, telescope = pcall(require, 'telescope') --pcall=if plugin is not loaded as expected insted of dosent crash neovim
    if not ok then
      vim.notify('Telescope not found!', vim.log.levels.WARN)
      return
    end
    --  :Telescope help_tags
    -- See `:help telescope` and `:help telescope.setup()`
    telescope.setup {

      defaults = { -- defaults start

        prompt_prefix = '   ', -- search icon
        selection_caret = ' ',
        path_display = { 'truncate' }, --smart/truncate

        mappings = { --mapping start
          i = { -- insert mode
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
          },
        },                         --maapping end

        file_ignore_patterns = {}, -- clear ignores
        vimgrep_arguments = {      -- fro live grep and grep string
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',    -- 👈 always search hidden files
          '--no-ignore', -- 👈 don’t respect .gitignore
        },
        -- mappings = {
        --   i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        -- },
      },          --default end

      pickers = { -- pickers start
        find_files = {
          layout_strategy = 'bottom_pane',
          layout_config = {
            height = 0.5,        -- take half screen from bottom
            preview_width = 0.6, -- preview on right
            prompt_position = 'top',
          },
          previewer = true, -- force previewer
          sorting_strategy = 'ascending',
        },
        buffers = {
          sort_lastused = true,
        },
      },             -- pickers ends

      extensions = { -- ext start
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown {},
          hidden = true, -- show dotfiles
          no_ignore = true,
        },
      }, -- ext ends
    }

    -- Enable Telescope extensions if they are installed
    telescope.load_extension 'fzf'
    telescope.load_extension 'ui-select'
    telescope.load_extension 'file_browser'
    -- telescope.load_extension("project")
    -- telescope.load_extension("dap")

    -- IF U WANT TO DO AUTO ISTEAD OF HARD CODE PULGINS INSTALL
    -- local extensions = { "fzf", "treesitter", "ui-select", "file_browser" }
    -- for _, ext in ipairs(extensions) do
    -- 	pcall(telescope.load_extension, ext)
    -- end

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sst', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })

    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
    vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Recent files old' })
    vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Commands' })
    -- vim.keymap.set("n", "<leader>fs", builtin.current_buffer_fuzzy_find, { desc = "Search in buffer" })

    -- Treesitter integration
    vim.keymap.set('n', '<leader>ft', builtin.treesitter, { desc = 'Treesitter symbols in buffer' })

    -- Git pickers
    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Git commits' })
    vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Git status' })

    -- File browser
    -- vim.keymap.set("n", "<leader>fe", ":Telescope file_browser<CR>", { desc = "File explorer" })
    vim.keymap.set('n', '<leader>fe', function()
      telescope.extensions.file_browser.file_browser()
    end, { desc = 'File explorer' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- search diagonistics current buff
    vim.keymap.set('n', '<leader>sD', function()
      builtin.diagnostics { bufnr = 0 }
    end, { desc = '[S]earch Buffer [D]iagnostics current bff' })

    --  `:help telescope.builtin.live_grep()`
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = 'Neovim configuration' })

    -- if added project.nvim
    --     vim.keymap.set("n", "<leader>fp", function()
    --   telescope.extensions.project.project{}
    -- end, { desc = "[F]ind [P]rojects" })
  end,
}
