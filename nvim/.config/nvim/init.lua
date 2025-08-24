require 'core.options'
require 'core.keymaps'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

--  To check the current status of your plugins, run
--    :Lazy
-- NOTE: Here is where you install your plugins.
require('lazy').setup {
  --STANDALONE PLUGINS need no dependencies
  require 'plugins.single.oil',          -- file manager
  require 'plugins.single.alpha',        -- greeter screen
  require 'plugins.single.indent-blank', -- the | lines that tells us the indent
  require 'plugins.single.misc',         -- small standalone plugins
  require 'plugins.single.vague',        --  be depressed colorscheme

  --COUPLES PLUGINS need each other
  require 'plugins.treesitter',  -- better syntax highlighting
  require 'plugins.telescope',   -- fuzzy finder
  require 'plugins.lsp.lsp-dev', -- lsp for lua
  --lsp
  require 'plugins.lsp.lsp',     -- lsp main
  require 'plugins.lsp.servers', -- lsp lang setup
  require 'plugins.lsp.mason',   -- lsp lang servers install here

  require 'plugins.null-ls',     --  auto formating + download formatters
  require 'plugins.blink-cmp',   -- completion for all lsp buff snip etc

  --USEFUUl PLUGINS
  require 'plugins.useful.md-view', -- to view makdown
}
