
# Startup
oh-my-posh init fish --config $HOME/.config/fish/zash.omp.json | source
afetch

# Keybinds
bind \cf fcd
bind \ch fhist
bind \ck 'clear; commandline -f repaint'

# Functions

# Fuzzy History
function fhist
    set cmd (history | fzf --tac)
    if test -n "$cmd"
        eval $cmd
    end
end

# Fuzzy CD
function fcd
    set choice (fd . | fzf)
    if test -z "$choice"
        return
    end
    if test -d "$choice"
        cd "$choice"
    else
        cd (dirname "$choice")
    end
end
