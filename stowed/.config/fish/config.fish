if test -d ~/.local/bin
    set PATH ~/.local/bin $PATH
end
if test -d ~/.cargo/bin
    set PATH ~/.cargo/bin $PATH
end
if test -d ~/.npm-packages/bin
    set -gx NPM_PACKAGES "$HOME/.npm-packages"
    set PATH ~/.npm-packages/bin $PATH
end

if status --is-interactive
    set -g fish_greeting

    if not type -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        cat ~/.config/fish/fish_plugins | fisher install
    end
end

if type -q direnv
    direnv hook fish | source
end
