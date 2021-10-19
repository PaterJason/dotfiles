set -gx NPM_PACKAGES "$HOME/.npm-packages"
set -gx PATH $PATH $NPM_PACKAGES/bin $HOME/.cargo/bin
# set -gx MANPATH $NPM_PACKAGES/share/man $MANPATH

set -g fish_greeting
