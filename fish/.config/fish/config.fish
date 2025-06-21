
# Startup
oh-my-posh init fish --config $HOME/.config/fish/weykn.zash.omp.json | source
afetch

# Keybinds
bind \cf fpath
bind \ch fhist
bind \ct fcmd

# Fzf
set -x FZF_DEFAULT_OPTS "
--height=40% --layout=reverse --info=inline --border
--color=fg:#cdd6f4,bg:#1e1e2e,fg+:#ffffff,bg+:#2a2a3c
--color=prompt:#f38ba8,pointer:#f38ba8,marker:#a6e3a1
--color=header:#89b4fa,info:#f9e2af,spinner:#94e2d5
--color=hl:#fab387,hl+:#f5c2e7
--pointer='󰆣'
"

# For pipx 
set PATH $PATH ~/.local/bin
