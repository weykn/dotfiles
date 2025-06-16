function fcd
    set choice (fd --hidden --exclude .git . | fzf)
    if test -z "$choice"
        return
    end

    if test -d "$choice"
        cd "$choice"
        echo "Changed directory: $choice"
    else
        set new_path (dirname "$choice")
        cd $new_path
        echo "Changed directory: $new_path"
    end
    
    commandline -f repaint
end