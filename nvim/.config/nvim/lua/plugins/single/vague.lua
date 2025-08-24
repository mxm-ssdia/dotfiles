return {
  'vague2k/vague.nvim',
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other plugins
  config = function()
    -- NOTE: you do not need to call setup if you don't want to.
    require('vague').setup {
      -- optional configuration here
      transparent = false, -- don't set background
      -- disable bold/italic globally in `style`
      bold = false,
      italic = false,

      colors = {
        bg = '#181818',
      },
    }
    vim.cmd 'colorscheme vague'
  end,
}
