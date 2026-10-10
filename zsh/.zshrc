# ============================================================
#  zsh — interactive config
#  Managed by stow:  cd ~/dotfiles && stow zsh
# ============================================================

# ---------- environment ----------
export EDITOR="${EDITOR:-vim}"
export VISUAL="$EDITOR"
export PAGER="${PAGER:-less}"
export LESS="-R"

# graphical password prompt for sudo when there is no TTY
# (Claude Code's `!` prompt, keybind-launched scripts, etc). Use: sudo -A <cmd>
export PATH="$HOME/.local/bin:$HOME/.config/scripts:$PATH"
[[ -x $HOME/.config/scripts/askpass.sh ]] && export SUDO_ASKPASS="$HOME/.config/scripts/askpass.sh"

# terminal depends on the session: foot under Wayland, kitty under X11/i3
if [[ -n $WAYLAND_DISPLAY ]]; then
    export TERMINAL=foot
else
    export TERMINAL=kitty
fi

# ---------- history ----------
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p "${HISTFILE:h}"
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS
setopt HIST_VERIFY            # let you edit !! before it runs
setopt EXTENDED_HISTORY       # record timestamps
setopt SHARE_HISTORY          # sync history across open terminals
setopt APPEND_HISTORY INC_APPEND_HISTORY

# ---------- shell behaviour ----------
setopt AUTO_CD                # typing a directory name cds into it
setopt AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt EXTENDED_GLOB GLOB_DOTS NO_CASE_GLOB
setopt INTERACTIVE_COMMENTS   # allow # comments at the prompt
setopt NO_BEEP
unsetopt FLOW_CONTROL         # frees ctrl-s / ctrl-q

# ---------- completion ----------
zmodload zsh/complist
autoload -Uz compinit

# only rebuild the completion dump once a day (keeps startup fast)
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
[[ -d ${_zcompdump:h} ]] || mkdir -p "${_zcompdump:h}"
if [[ -n ${_zcompdump}(#qN.mh+24) ]]; then
    compinit -d "$_zcompdump"
else
    compinit -C -d "$_zcompdump"
fi

zstyle ':completion:*' menu select
# case-insensitive, then partial-word (f-b -> foo-bar), then substring
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{110}%B %d %b%f'
zstyle ':completion:*:messages'     format '%F{110} %d%f'
zstyle ':completion:*:warnings'     format '%F{167} no matches%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other

# ---------- keybindings ----------
bindkey -e                                  # emacs-style
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line
bindkey '^[[3~'   delete-char
bindkey '^[[1;5C' forward-word              # ctrl+right
bindkey '^[[1;5D' backward-word             # ctrl+left
bindkey '^H'      backward-kill-word        # ctrl+backspace
bindkey '^[[Z'    reverse-menu-complete     # shift+tab
# in the completion menu, hjkl-ish navigation
bindkey -M menuselect '^[[Z' reverse-menu-complete

# ---------- plugins ----------
# autosuggestions: fish-style inline suggestion from history + completions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5d6b7a'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] \
    && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# syntax highlighting MUST be sourced after autosuggestions
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] \
    && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# history-substring-search MUST come after syntax highlighting
if [[ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    # type a prefix, then up/down walks only matching history entries
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
fi

# ---------- fzf ----------
export FZF_DEFAULT_OPTS="--height 45% --layout=reverse --border=rounded --info=inline \
--color=bg+:#262b33,bg:-1,spinner:#8fd0e8,hl:#6ea8de \
--color=fg:#c9d1dc,header:#6ea8de,info:#8f9aa8,pointer:#8fd0e8 \
--color=marker:#8bc48a,fg+:#f0f4fa,prompt:#6ea8de,hl+:#8fd0e8"
if command -v fd >/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]]   && source /usr/share/fzf/completion.zsh

# ---------- aliases ----------
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -p'
alias df='df -h'
alias free='free -h'

if command -v eza >/dev/null; then
    alias ls='eza --group-directories-first --icons=auto'
    alias ll='eza -l  --group-directories-first --icons=auto --git'
    alias la='eza -la --group-directories-first --icons=auto --git'
    alias lt='eza --tree --level=2 --icons=auto'
else
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -lh'
    alias la='ls -lah'
fi

# `bat` is installed as a nicer pager/viewer; `cat` is left alone on purpose
# so scripts and pipes behave exactly as expected.
command -v bat >/dev/null && alias catt='bat --paging=never'

# ---------- integrations ----------
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"            # `z <dir>` jumps

# ---------- prompt ----------
if command -v starship >/dev/null; then
    eval "$(starship init zsh)"

    # Transient prompt: once you hit enter, the prompt above collapses to a
    # bare "❯". Only the line you are actively typing at carries the full
    # directory / git / time row, so scrollback stays one line per command.
    # starship 1.26 has no enable_transience for zsh, so this does it via zle.
    _PROMPT_FULL=$PROMPT
    _RPROMPT_FULL=$RPROMPT
    # hex (not %F{110}) -> standard truecolor escape and an exact match for
    # starship's accent; the 256-colour form emits colon-separated SGR that
    # some terminals will not parse.
    _PROMPT_SHORT='%B%F{#6ea8de}❯%f%b '

    _prompt_short() { PROMPT=$_PROMPT_SHORT; RPROMPT=''; }
    _prompt_full()  { PROMPT=$_PROMPT_FULL;  RPROMPT=$_RPROMPT_FULL; }

    autoload -Uz add-zle-hook-widget add-zsh-hook

    # zle .reset-prompt only SCHEDULES a redraw, so zle -R is needed to force
    # the repaint before the line is committed. The full prompt is restored in
    # precmd, not here -- restoring it immediately would make the scheduled
    # redraw use the full prompt again and defeat the whole thing.
    _transient_finish() { _prompt_short; zle .reset-prompt; zle -R; }
    add-zle-hook-widget line-finish _transient_finish
    add-zsh-hook precmd _prompt_full

    # ctrl-c should leave a collapsed prompt behind too
    TRAPINT() { _prompt_short; zle && { zle .reset-prompt; zle -R; }; return $((128 + $1)); }
fi

# ---------- greeting ----------
# Runs once per top-level interactive shell, not in subshells or pipes.
# Set NOFETCH=1 before launching a terminal to skip it.
if [[ -o interactive && -t 1 && -z $_FETCH_SHOWN && -z $NOFETCH ]]; then
    export _FETCH_SHOWN=1
    command -v fastfetch >/dev/null && fastfetch
fi

# ---------- local overrides ----------
# anything machine-specific goes here, untracked
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
