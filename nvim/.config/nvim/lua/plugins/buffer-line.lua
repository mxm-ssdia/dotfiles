return {
    'akinsho/bufferline.nvim', 
    version = "*", 
    dependencies = {
        'nvim-tree/nvim-web-devicons'
    },
    config = function ()
        require("bufferline").setup{
            options = {
  mode = "tabs",
  themable = true,
  modified_icon = '●',
  show_buffer_close_icons = false,
  show_close_icon = true,
  separator_style = { "│", "│" },
  enforce_regular_tabs = true,
  always_show_bufferline = true,
  indicator = { style = "none" },
}

  }
    end
}
