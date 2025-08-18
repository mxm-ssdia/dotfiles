--[[

    install ripgrep for live grep

]]--

return {
    'nvim-telescope/telescope.nvim', --install telescope 
    event = 'VimEnter',

    dependencies = {
      'nvim-lua/plenary.nvim', -- required u got it 
      { 
        -- native telescope sorter impove sorter performance
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make', -- run cmd when plugin = installled not when nvim startup
        cond = function() -- cond if plugin should be install & loaded
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font }, -- for icons nerd font must be install
        'nvim-treesitter/nvim-treesitter',

        --OPTIONAL
        --[[
        "sharkdp/fd", --(finder)
        "neovim LSP", --(picker)
        "devicons", --(icons)
        ]]--

    },

    config = function()
     --  :Telescope help_tags
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {

        defaults = {
                 file_ignore_patterns = {}, -- clear ignores
    vimgrep_arguments = { -- fro live grep and grep string
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",       -- 👈 always search hidden files
      "--no-ignore",    -- 👈 don’t respect .gitignore
    },
          -- mappings = {
          --   i = { ['<c-enter>'] = 'to_fuzzy_refine' },
          -- },
        },
         pickers = { --for find files
             find_files = {
       theme = "dropdown",
      -- theme = "get_cursor",
      -- theme = "get_ivy",
       hidden = true,         -- show dotfiles
       no_ignore = true,      -- don’t respect .gitignore
    },
},
            -- }
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
             hidden = true,     -- show dotfiles
             no_ignore = true,
          },
        },

      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require("telescope").load_extension, "treesitter")

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set("n", "<leader>st", "<cmd>Telescope treesitter<cr>", { desc = "[S]earch [T]reesitter symbols" })


      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

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
      end, { desc = '[S]earch [N]eovim files' })
    end,
  }
