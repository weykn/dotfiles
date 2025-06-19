function fcmd
    set cmd (complete -C"" | fzf --tac | cut -f1)
    copypaste $cmd
end