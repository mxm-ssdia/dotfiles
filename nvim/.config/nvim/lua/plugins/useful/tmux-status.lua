local function tmux_info()
  if vim.fn.exists '$TMUX' == 0 then
    return ''
  end

  local session = vim.fn.system("tmux display-message -p '#S'"):gsub('\n', '')
  if session == '' then
    return ''
  end

  local width = vim.fn.winwidth(0)

  -- define highlight groups once
  vim.api.nvim_set_hl(0, 'LualineTmuxSession', { bold = true })
  vim.api.nvim_set_hl(0, 'LualineTmuxActive', { fg = '#ffffff', bg = '#5c6370' })
  vim.api.nvim_set_hl(0, 'LualineTmuxInactive', { fg = '#c0c0c0' })

  -- small screen: session + current tab
  if width < 80 then
    local current = vim.fn.system("tmux display-message -p '#W'"):gsub('\n', '')
    return table.concat {
      '%#LualineTmuxSession#',
      session,
      '%#Normal#',
      ':',
      '%#LualineTmuxActive#',
      ' ' .. current .. ' ',
      '%#Normal#',
    }
  end

  -- big screen: all tabs
  local output = vim.fn.systemlist "tmux list-windows -F '#W #{window_active}'"
  if not output or #output == 0 then
    return ''
  end

  local chunks = {}
  table.insert(chunks, '%#LualineTmuxSession#' .. session .. '%#Normal#: ')

  for i, line in ipairs(output) do
    local name, active = line:match '^(.*) (%d+)$'
    if name then
      if active == '1' then
        table.insert(chunks, '%#LualineTmuxActive# ' .. name .. ' ')
      else
        table.insert(chunks, '%#LualineTmuxInactive#' .. name)
      end
      if i < #output then
        table.insert(chunks, '%#Normal# │ ')
      end
    end
  end

  return table.concat(chunks)
end -- <-- ✅ this was missing

return tmux_info
