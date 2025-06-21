function fpath
    set choice (fd --hidden --exclude .git . | fzf)
    if test -z "$choice"
        commandline -f repaint
        return
    end

    copypaste $choice
end
