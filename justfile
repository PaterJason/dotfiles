[group('stow')]
stow:
  stow -R stowed

[group('stow')]
unstow:
  stow -D stowed

[group('get binary')]
get-neovim:
  -pkill --echo --uid "$USER" --exact nvim
  gh release download nightly --pattern 'nvim-linux-x86_64.appimage' --repo 'neovim/neovim' --clobber -O ~/.local/bin/nvim
  chmod u+x ~/.local/bin/nvim
  nvim --version

[group('get binary')]
get-emmylua-ls:
  gh release download --pattern 'emmylua_ls-linux-x64.tar.gz' --repo 'EmmyLuaLs/emmylua-analyzer-rust' -O - | tar -xzvf - -C ~/.local/bin/
  emmylua_ls --version

[group('get binary')]
get-expert:
  gh release download nightly --pattern 'expert_linux_amd64' --repo elixir-lang/expert  --clobber -O ~/.local/bin/expert
  chmod u+x ~/.local/bin/expert
