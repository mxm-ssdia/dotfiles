-- #require#
-- blink_cmp
-- nvm-lspconfig
-- plenary
-- telescope
return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = { --opt start
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv", "uv", "vim%.loop" } }, --adds Neovim’s async/event loop APIs (like vim.uv) with correct typing.
				{ path = "plenary.nvim" }, -- completion for require("plenary.job")
				{ path = "telescope.nvim" }, -- IntelliSense for require("telescope.builtin")
			},
		}, -- opt end
		dependencies = { --dep start
			{ "Bilal2453/luvit-meta", lazy = true }, --[if u want to bbecome plugin dev]
		}, -- dep end
	},
}
