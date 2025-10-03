stow:
  stow -R stowed

unstow:
  stow -D stowed

get-neovim:
  -pkill --echo --uid "$USER" --exact nvim
  gh release download nightly --pattern 'nvim-linux-x86_64.appimage' --repo 'neovim/neovim' --clobber -O ~/.local/bin/nvim
  chmod u+x ~/.local/bin/nvim
  nvim --version

get-emmylua-ls:
  gh release download --pattern 'emmylua_ls-linux-x64.tar.gz' --repo 'EmmyLuaLs/emmylua-analyzer-rust' -O - | tar -xzvf - -C ~/.local/bin/
  emmylua_ls --version
