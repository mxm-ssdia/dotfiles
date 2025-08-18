-- #require# 
-- nvm-cmp plugin
-- nvm-lspconfig
-- plenary
-- telescope
return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },--adds Neovim’s async/event loop APIs (like vim.uv) with correct typing.
          { path = "plenary.nvim" }, -- completion for require("plenary.job")
          { path = "telescope.nvim" }, -- IntelliSense for require("telescope.builtin")
      },
    },
  },
}
