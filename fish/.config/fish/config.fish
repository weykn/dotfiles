
# Startup
oh-my-posh init fish --config $HOME/.config/fish/zash.omp.json | source
afetch

# Keybinds
bind \cf fcd
bind \ch fhist

# Fuzzy History
function fhist
    set cmd (history | fzf --tac)
    if test -n "$cmd"
        echo -n $cmd | xclip -selection clipboard
        echo "Copied: $cmd"
        commandline -f repaint
    end
end

# Fuzzy CD
function fcd
    set choice (fd --hidden --exclude .git . | fzf)
    if test -z "$choice"
        return
    end

    if test -d "$choice"
        cd "$choice"
        echo "Changed directory: $choice"
    else
        set new_path (dirname "$choice")
        cd $new_path
        echo "Changed directory: $new_path"
    end
    
    commandline -f repaint
end

# For pipx 
set PATH $PATH ~/.local/bin
