function fhist
    set cmd (history | fzf --tac)
    copypaste $cmd
end