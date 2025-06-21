function fcmd
    set cmd (complete -C"" | fzf --tac | cut -f1)
    if test -z "$cmd"
        commandline -f repaint
        return
    end

    copypaste $cmd
end
