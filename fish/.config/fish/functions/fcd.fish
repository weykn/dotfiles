function fcd
    set choice (fd --hidden --exclude .git . | fzf)
    if test -z "$choice"
        return
    end

    commandline -i $choice
end
