return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require('lualine').setup {
             options = {
                icons_enabled = true,
                theme = 'palenight',
                disabled_filetypes = { 'alpha', 'oil' },
            },
            extensions = { 'fugitive' }, -- show git diff
        }
    end 
}

