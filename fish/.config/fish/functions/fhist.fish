function fhist
    set cmd (history | fzf --tac)
    if test -z "$cmd"
        commandline -f repaint
        return
    end

    copypaste $cmd
end
