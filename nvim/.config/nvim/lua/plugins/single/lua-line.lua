return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local tmux_status = require 'plugins.useful.tmux-status'

    require('lualine').setup {
      options = {
        icons_enabled = true,
        theme = 'palenight',
        disabled_filetypes = { 'alpha', 'oil' },
        component_separators = { left = ')', right = '(' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_c = {
          function()
            return tmux_status() -- notice () instead of .tmux_info()
          end,
        },                       -- shows "session:window"
      },
      extensions = { 'fugitive' },
    }
  end,
}
