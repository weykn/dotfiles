function fcd
    set choice (fd --hidden --exclude .git . | fzf)
    if test -z "$choice"
        return
    end

    if test -d "$choice"
        set dir "$choice"
        set cmd "cd $dir"
    else
        set dir (dirname "$choice")
        set name (basename "$choice")
        set cmd "cd $dir # $name"
    end

    commandline -i $cmd
end
