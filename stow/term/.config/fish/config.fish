eval (dircolors -c)

# neovim
if type -q nvim
  set -gx EDITOR nvim
  set -gx VISUAL nvim
end

set -gx NPM_PACKAGES "$HOME/.npm-packages"
set -gx PATH $PATH $NPM_PACKAGES/bin $HOME/.cargo/bin
# set -gx MANPATH $NPM_PACKAGES/share/man $MANPATH
