vim.filetype.add({
  extension = {
    cljd = 'clojure',
  },
  filename = {
    ['.zprintrc'] = 'clojure',
  },
  pattern = {
    ['.*/%.config/zathura/.*'] = 'zathurarc',
    ['.*'] = function(path, bufnr)
      return vim.bo[bufnr]
          and vim.bo[bufnr].filetype ~= 'bigfile'
          and vim.fn.getfsize(path) > (1024 * 500) -- 500 KB
          and 'bigfile'
        or nil
    end,
  },
})
