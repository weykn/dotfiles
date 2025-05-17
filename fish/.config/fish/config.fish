oh-my-posh init fish --config $HOME/.config/fish/zash.omp.json | source
if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
end
