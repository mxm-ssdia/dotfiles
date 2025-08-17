return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup{
             options = {
                icons_enabled = true,
                theme = 'palenight',
                disabled_filetypes = { 'alpha', 'oil' },
                component_separators = { left = ')', right = '('},
                section_separators = { left = '', right = ''},
            },
            extensions = { 'fugitive' },
        }
    end 
}

