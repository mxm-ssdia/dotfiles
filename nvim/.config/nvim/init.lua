require("core.options")
require("core.keymaps")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

--  To check the current status of your plugins, run
--    :Lazy
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
	--STANDALONE PLUGINS need no dependencies
	require("plugins.oil"), -- file manager
	require("plugins.oil-git"), -- git sign for oil
	require("plugins.buffer-line"), -- only use for tabs no buffers
	require("plugins.lua-line"), -- the status line  inset visula etc
	require("plugins.null-ls"), --  auto formating
	require("plugins.gitsigns"), -- git signs on buffers
	require("plugins.alpha"), -- greeter screen
	require("plugins.indent-blank"), -- the | lines that tells us the indent
	require("plugins.misc"), -- small standalone plugins

	--COUPLES PLUGINS need each other
	require("plugins.treesitter"), -- better syntax highlighting
	require("plugins.telescope"), -- fuzzy finder
	require("plugins.lsp.lsp"), -- lsp integerationn
	require("plugins.lsp.lsp-dev"), -- lsp for lua
	-- require 'plugins.nvm-cmp' -- completion for all lsp buff snip etc
	require("plugins.blink-cmp"), -- completion for all lsp buff snip etc

	-- STUPID PLUGINS I LIKE :)
	require("plugins.fuck-u.cursor-smear"), -- cursor animation kela !!!
	require("plugins.fuck-u.lineNO-smear"), -- smear the line no we are on
})
