local devicons = require "nvim-web-devicons"

local ns_id = vim.api.nvim_create_namespace "netrw"
local augroup = vim.api.nvim_create_augroup("netrw", {})

local patterns = {
  comment = [[".*\%(\t\|$\)]],
  dir1 = [[\.\{1,2}/]],
  dir2 = [[\%(\S\+ \)*\S\+/\ze\%(\s\{2,}\|$\)]],
  tree_bar = [[^\%([-+|] \)\+]],
  sym_link = [[\%(\S\+ \)*\S\+@\ze\%(\s\{2,}\|$\)]],
  exe = [[\%(\S\+ \)*\S*[^~]\*\ze\%(\s\{2,}\|$\)]],
  plain = [[\(\S\+ \)*\S\+]],
  compress = [[\(\S\+ \)*\S\+\.\%(gz\|bz2\|Z\|zip\)\>]],
}

vim.api.nvim_create_autocmd("BufModifiedSet", {
  buffer = 0,
  group = augroup,
  callback = function()
    if vim.bo.filetype ~= "netrw" then
      return
    end

    if vim.b["netrw_liststyle"] == 2 then
      return
    end

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for lnum, line in ipairs(lines) do
      local icon_text, icon_hl
      line = vim.fn.substitute(line, patterns.comment, "", "g")

      if 0 <= vim.fn.match(line, patterns.dir1) then
        icon_text, icon_hl = "", "netrwDir"
      elseif 0 <= vim.fn.match(line, patterns.dir2) then
        if
          string.len(vim.fn.matchstr(line, patterns.tree_bar))
          >= string.len(vim.fn.matchstr(lines[lnum + 1], patterns.tree_bar))
        then
          icon_text, icon_hl = "", "netrwDir"
        else
          icon_text, icon_hl = "", "netrwDir"
        end
      elseif 0 <= vim.fn.match(line, patterns.sym_link) then
        icon_text, icon_hl = "", "netrwLink"
      elseif 0 <= vim.fn.match(line, patterns.exe) then
        icon_text, icon_hl = "󱆃", "netrwExe"
      elseif 0 <= vim.fn.match(line, patterns.compress) then
        icon_text, icon_hl = "", "netrwDir"
      elseif 0 <= vim.fn.match(line, patterns.plain) then
        local str = vim.fn.matchstr(line, patterns.plain)
        local devicon_text, devicon_hl = devicons.get_icon(str, nil)
        if devicon_text ~= nil then
          icon_text, icon_hl = devicon_text, devicon_hl
        else
          local default_icon = devicons.get_default_icon()
          icon_text, icon_hl = default_icon.icon, default_icon.name
        end
      end

      if icon_text ~= nil then
        vim.api.nvim_buf_set_extmark(0, ns_id, lnum - 1, -1, {
          id = lnum,
          sign_text = icon_text,
          priority = 5,
          sign_hl_group = icon_hl,
        })
      end
    end
  end,
})
