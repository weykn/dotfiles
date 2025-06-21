function copypaste
    set cmd $argv
    if test -n "$cmd"
        echo -n $cmd | xclip -selection clipboard
        commandline -i "$cmd"
        commandline -f repaint
        commandline -f repaint
    end
end