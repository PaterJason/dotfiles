# fzf
if type -q fzf
  fzf_key_bindings
end

if type -q bat
  set -gx MANPAGER "sh -c 'col -bx | bat -l man --paging=always -p'"
end

eval (dircolors -c)

# neovim
if type -q nvim
  set -gx EDITOR nvim
  set -gx VISUAL nvim
end

if test -d ~/bin
  set -gx PATH ~/bin $PATH
end

set -gx NPM_PACKAGES "$HOME/.npm-packages"
set -gx PATH $PATH $NPM_PACKAGES/bin
set -gx MANPATH $NPM_PACKAGES/share/man $MANPATH
