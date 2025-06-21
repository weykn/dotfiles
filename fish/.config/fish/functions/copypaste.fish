function copypaste
    set cmd $argv
    if test -n "$cmd"
        echo -n $cmd | xclip -selection clipboard
        commandline -i "$cmd"
    end
end