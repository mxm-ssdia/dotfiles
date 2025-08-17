return { 
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
    config = function() 
        require'nvim-treesitter.configs'.setup {
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
            auto_install = true,
             textobjects = { -- TEXT OBJECTS###############
    select = {
      enable = true,
      lookahead = true, -- jump forward to textobj
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },

  incremental_selection = { -- INCREMENTAL SEL########################
    enable = true,
    keymaps = {
      -- init_selection = "gnn",     -- start selection
      -- node_incremental = "grn",   -- expand to next node
      -- scope_incremental = "grc",  -- expand to scope
      -- node_decremental = "grm",   -- shrink
      init_selection = "<C-Space>",   -- start selection
      node_incremental = "<C-Space>", -- expand to next node
      scope_incremental = "<C-s>",    -- expand to scope
      node_decremental = "<C-Backspace>", -- shrink
    },
  },

   indent = { -- INDENT ###################################
    enable = true
  },
  
            highlight = { --HIGHLIGHTS####################
                enable = true,
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,

            additional_vim_regex_highlighting = true, -- true slow cmptur
  },
}
    end,

  }


