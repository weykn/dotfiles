function fhist
    set cmd (history | fzf --tac)
    if test -n "$cmd"
        echo -n $cmd | xclip -selection clipboard
        echo "Copied: $cmd"
        commandline -f repaint
    end
end