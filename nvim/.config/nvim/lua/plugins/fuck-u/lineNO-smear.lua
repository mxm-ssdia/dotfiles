return {
	"gen740/SmoothCursor.nvim",
	config = function()
		require("smoothcursor").setup({
			autostart = true,
			cursor = "", -- or any character
			texthl = "SmoothCursor",
			linehl = nil,
			fancy = {
				enable = true, -- "snake" style
				head = { cursor = "▷", texthl = "SmoothCursor" },
				body = {
					{ cursor = "", texthl = "SmoothCursor" },
					{ cursor = "●", texthl = "SmoothCursor" },
					{ cursor = "•", texthl = "SmoothCursor" },
				},
			},
		})
	end,
}
