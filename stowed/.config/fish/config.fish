fish_add_path ~/.npm-packages/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.local/bin

set -gx NPM_PACKAGES "$HOME/.npm-packages"

if status --is-interactive
    set -g fish_greeting
end

if type -q direnv
    direnv hook fish | source
end

set fish_color_normal 4c4f69
set fish_color_command 1e66f5
set fish_color_param dd7878
set fish_color_keyword d20f39
set fish_color_quote 40a02b
set fish_color_redirection ea76cb
set fish_color_end fe640b
set fish_color_error d20f39
set fish_color_gray 9ca0b0
set fish_color_selection --background=ccd0da
set fish_color_search_match --background=ccd0da
set fish_color_operator ea76cb
set fish_color_escape dd7878
set fish_color_autosuggestion 9ca0b0
set fish_color_cancel d20f39
set fish_color_cwd df8e1d
set fish_color_user 179299
set fish_color_host 1e66f5
set fish_pager_color_progress 9ca0b0
set fish_pager_color_prefix ea76cb
set fish_pager_color_completion 4c4f69
set fish_pager_color_description 9ca0b0
