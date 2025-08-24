-- Standalone plugins with less than 10 lines of config go here
return {
  {
    -- Tmux & split window navigation
    'christoomey/vim-tmux-navigator',
  },
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },
  {
    -- Powerful Git integration for Vim
    'tpope/vim-fugitive',
  },
  {
    -- GitHub integration for vim-fugitive
    'tpope/vim-rhubarb',
  },
  {
    -- Hints keybinds
    'folke/which-key.nvim',
  },
  {
    -- Autoclose parentheses, brackets, quotes, etc.
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {},
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- High-performance color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  },
  {
    'sphamba/smear-cursor.nvim',
    opts = {
      stiffness = 0.5,
      trailing_stiffness = 0.5,
      distance_stop_animating = 0.5,
      never_draw_over_target = false,
    },
  },
  {
    'gen740/SmoothCursor.nvim',
    config = function()
      require('smoothcursor').setup {
        autostart = true,
        cursor = '', -- or any character
        texthl = 'SmoothCursor',
        linehl = nil,
        fancy = {
          enable = true, -- "snake" style
          head = { cursor = '▷', texthl = 'SmoothCursor' },
          body = {
            { cursor = '', texthl = 'SmoothCursor' },
            { cursor = '●', texthl = 'SmoothCursor' },
            { cursor = '•', texthl = 'SmoothCursor' },
          },
        },
      }
    end,
  },
}
