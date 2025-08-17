require "core.options"
require "core.keymaps"


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
require('lazy').setup({
    require 'plugins.oil', -- file manager
    require 'plugins.oil-git', -- file manager & git sign
    require 'plugins.buffer-line', -- only use for tabs >>>> buffers
    require 'plugins.lua-line', -- the status line 
    require 'plugins.treesitter', -- better syntax highlighting
})
