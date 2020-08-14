local nvim_lsp = require 'nvim_lsp'
local configs = require'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

nvim_lsp.bashls.setup{}
nvim_lsp.cssls.setup{}
nvim_lsp.html.setup{}
nvim_lsp.jsonls.setup{}
nvim_lsp.vimls.setup{}
nvim_lsp.sumneko_lua.setup{}

configs.clojure_lsp = {
  default_config = {
    cmd = {'/home/jason/.bin/clojure-lsp'};
    filetypes = {'clojure'};
    root_dir = util.root_pattern("deps.edn", "project.clj");
    init_options = {
      ignoreClasspathDirectories = true,
    };
  };
  docs = {
    description = [[
https://github.com/snoe/clojure-lsp

A Language Server for Clojure. Taking a Cursive-like approach of statically analyzing code.
]];
    default_config = {
      root_dir = util.root_pattern("deps.edn", "project.clj");
    };
  };
}
nvim_lsp.clojure_lsp.setup{}
