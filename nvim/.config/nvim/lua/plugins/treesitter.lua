--[[
    why treesittter?
    #Syntax Highlighting & Indentation
    #Text Objects
    #Motions / Navigation
    #Refactoring (plugin: nvim-treesitter-refactor)
    #Playground (plugin: nvim-treesitter/playground)
    #Incremental Selection
    #Folding
    #Query-based Extensions

    FOLDING----
        zc → close (fold) the block under cursor.
        zo → open fold.
        za → toggle fold.
        zR → open all folds.
        zM → close all folds.

        #PARSERS [grammer for any languages]
        :TSInstallInfo -- list of availabe language parser
        :TSUpdate -- update all language parser

        #MODULES [for highlighting,indentstion,folding,]
        :TSBufEnable {module} " enable module on current buffer
        :TSBufDisable {module} " disable module on current buffer
        :TSEnable {module} [{ft}] " enable module on every buffer. If filetype is specified, enable only for this filetype.
        :TSDisable {module} [{ft}] " disable module on every buffer. If filetype is specified, disable only for this filetype.
        :TSModuleInfo [{module}] " list information about modules state for each filetype

        :h nvim-treesitter-commands for a list of all available commands.

	dependent file - telescope.lua for a key map


 ]]
--

return {
	{
		'nvim-treesitter/nvim-treesitter', --main link for treesitter
		build = ':TSUpdate',   --make sure installed parsers are updated to the latest version
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
			'nvim-treesitter/nvim-treesitter-refactor',
		},
		config = function()
			require('nvim-treesitter.configs').setup {
				ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' }, --MODULES INSTALL
				sync_install = false,                                               -- Install parsers synchronously (only applied to `ensure_installed`)
				auto_install = true,                                                -- install missing parsers
				-- ignore_install = { "javascript" }, -- List of parsers to ignore installing (or "all")

				textobjects = { -- TEXT OBJECTS###############
					select = {
						enable = true,
						lookahead = true, -- jump forward to textobj
						keymaps = {
							['af'] = '@function.outer',
							['if'] = '@function.inner',
							['ac'] = '@class.outer',
							['ic'] = '@class.inner',
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							[']f'] = '@function.outer',
							[']c'] = '@class.outer',
						},
						goto_previous_start = {
							['[f'] = '@function.outer',
							['[c'] = '@class.outer',
						},
					},
					swap = {
						enable = true,
						swap_next = {
							['<leader>a'] = '@parameter.inner',
						},
						swap_previous = {
							['<leader>A'] = '@parameter.inner',
						},
					},
				},

				incremental_selection = { --IC start
					enable = true,
					keymaps = {
						init_selection = '<Leader>ss', -- start selection
						node_incremental = '<Leader>ss', -- expand to next node
						scope_incremental = '<Leader>sc', -- expand to scope
						node_decremental = '<Leader>sd', -- shrink
					},
				},            --IC end

				--##we wont use this we will use lsp for this stuff
				-- refactor = { --refactor start
				-- 	highlight_definitions = { enable = true },
				-- 	highlight_current_scope = { enable = true },
				-- 	smart_rename = {
				-- 		enable = true,
				-- 		keymaps = {
				-- 			smart_rename = "grr", -- rename symbol under cursor
				-- 		},
				-- 	},
				-- 	navigation = {
				-- 		enable = true,
				-- 		keymaps = {
				-- 			goto_definition = "gnd",
				-- 			list_definitions = "gnD",
				-- 			list_definitions_toc = "gO",
				-- 			goto_next_usage = "<a-*>",
				-- 			goto_previous_usage = "<a-#>",
				-- 		},
				-- 	},
				-- }, -- refactor start

				indent = { enable = true }, -- start the new line from same starting point as last line
				highlight = { --HL start
					enable = true,
					-- disable = { "c", "rust" }, -- name of the parsers to ignore highlighting
					disable = function(lang, buf) -- disable slow treesitter highlight for large files
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = true,
				}, --HL end
			}

			-- 🔥 Custom highlight overrides
			-- :h treesitter-highlight-groups for details.
			-- vim.api.nvim_set_hl(0, "@foo.bar.lua", { link = "Identifier" })
			-- Example: make function calls bold
			-- vim.api.nvim_set_hl(0, "@function.call", { bold = true, fg = "#FFD700" })
		end,
	},

	-- Treesitter Playground (for debugging/learning AST)
	{ 'nvim-treesitter/playground',     cmd = 'TSPlaygroundToggle' }, -- :TSPlaygroundToggle
	{ 'hiphish/rainbow-delimiters.nvim' },                  --rainbow color brackets
	-- { "nvim-treesitter/nvim-treesitter-context" }, --sticky fun class header at top
	{ 'windwp/nvim-ts-autotag' },                           --auto rename html/jsx tag
	{ 'andymass/vim-matchup' },                             --enhanced matching if else
	{ 'numToStr/Comment.nvim',          opts = {} },        --samter comment aware of AST

	--[[
   Place cursor on a function → run :echo nvim_treesitter#statusline(90)
   :Telescope treesitter and you’ll see a list of all functions/variables/classes in that file.
  --]]
	--
}
