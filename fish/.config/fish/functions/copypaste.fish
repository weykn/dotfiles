function copypaste
    set cmd $argv
    if test -n "$cmd"
        echo -n $cmd | xclip -selection clipboard
        echo "Copied!"
        commandline -i "$cmd"
        commandline -f repaint
    end
end