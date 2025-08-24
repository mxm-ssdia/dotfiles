return {
  'vague2k/vague.nvim',
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other plugins
  config = function()
    -- NOTE: you do not need to call setup if you don't want to.
    require('vague').setup {
      -- optional configuration here
      transparent = true, -- don't set background
      -- disable bold/italic globally in `style`
      bold = false,
      italic = false,

      colors = {
        -- bg = '#181818', -- dark
        -- bg = '#191C27', --little blue
        -- bg = '#151922',
        bg = '#1A2228',
        -- bg = '#1A1E28',
        string = '#8a739a',
        func = '#bc96b0',
        keyword = '#787bab',
        number = '#CCCCFF',
        line = '#252530',
        inactiveBg = '#1c1c24',
        fg = '#cdcdcd',
        floatBorder = '#878787',
        comment = '#606079',
        builtin = '#b4d4cf',
        property = '#c3c3d5',
        constant = '#aeaed1',
        parameter = '#bb9dbd',
        visual = '#303030', -- visual selection
        error = '#d8647e',
        warning = '#f3be7c',
        hint = '#7e98e8',
        operator = '#90a0b5',
        type = '#9bb4bc',
        search = '#405065',
        plus = '#7fa563',
        delta = '#f3be7c',
      },
    }
    vim.cmd 'colorscheme vague'
  end,
}
