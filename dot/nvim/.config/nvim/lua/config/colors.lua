vim.g.nord_italic = 1
vim.g.nord_italic_comments = 1
vim.g.nord_underline = 1
vim.cmd'colorscheme nord'

-- LSP
vim.tbl_map(
  function (d)
    local hl_group = 'LSPDiagnostics' .. d
    local get_fg = function(env)
      return ' ' .. env .. 'fg=' .. vim.fn.synIDattr(vim.fn.hlID(hl_group), 'fg', env)
    end
    local hl = get_fg('cterm') .. get_fg('gui')
    local hl_ul =  hl .. ' cterm=underline gui=underline'
    vim.cmd('hi LspDiagnosticsDefault' .. d .. hl)
    vim.cmd('hi LspDiagnosticsUnderline' .. d .. hl_ul)
    vim.fn.sign_define('LspDiagnosticsSign' .. d, {text = '', numhl = hl_group})
  end,
  {'Hint', 'Error', 'Warning', 'Information'})

vim.cmd'hi link LspReferenceRead Underline'
vim.cmd'hi link LspReferenceText Underline'
vim.cmd'hi link LspReferenceWrite Underline'
