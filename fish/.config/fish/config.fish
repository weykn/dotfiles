
# Startup
oh-my-posh init fish --config $HOME/.config/fish/weykn.zash.omp.json | source
afetch

# Keybinds
bind \cf fpath
bind \ch fhist
bind \ct fcmd

# For pipx 
set PATH $PATH ~/.local/bin
