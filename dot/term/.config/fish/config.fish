# fish_vi_key_bindings
fzf_key_bindings

set -gx fish_greeting ""

# fzf
set -gx FZF_DEFAULT_COMMAND "fd --type f"
set -gx FZF_CTRL_T_COMMAND "fd"
set -gx FZF_ALT_C_COMMAND "fd --type d"
set -gx FZF_ALT_C_OPTS "--preview 'tree -C {} | head -200'"
set -gx FZF_CTRL_T_OPTS "--preview 'bat --line-range :200 {} 2> /dev/null|| tree -C {} | head -200'"

eval (dircolors -c)

# neovim
if type -q nvim
  set -gx EDITOR nvim
  set -gx VISUAL nvim
  set -gx MANPAGER "nvim +Man!"
end
