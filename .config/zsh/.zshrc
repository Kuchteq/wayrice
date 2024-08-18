# Luke's config for the Zoomer Shell
# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Before a heavy script, just put zsh-defer before to not drag down the initial prompt process
# Better yet, put it in the lazy-load function as calling zsh-defer multiple times also impacts performance
source ~/.config/zsh/plugins/zsh-defer/zsh-defer.plugin.zsh

setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
echo -ne '\e[5 q' # Use beam shape cursor on startup.

# Use lf to switch directories and bind it to ctrl-o
lfcd() {
    echo -e '\e[2A'
    setopt nojobprint nopwdprint >/dev/null 2>&1
    NEED_LFCD_SYNC=true
    if jobs "$LFCD_JOB_ID" >/dev/null 2>&1; then
            echo -ne "\033]0; $PWD\007"
            lf -remote "send $LF_INSTANCE_ID cd \"$PWD\"; on-cd" 
            fg "$LFCD_JOB_ID"
    else 
            export LAST_DIR_PATH="$XDG_RUNTIME_DIR/lf_lastdir"
            LFCD_JOB_ID=lf
            unset LFCD_FOCUSPATH
            lf --command on-quit-freeze -last-dir-path="$LAST_DIR_PATH" "${@}"
    fi
    unsetopt nojobprint nopwdprint >/dev/null 2>&1
}
# use a nice folder unicode character as an alias to lfcd so that useless lfcd calls don't pollute the prompt
alias 󱉆=lfcd
precmd-lf-yank() {
       preyankbuf=${BUFFER}; preyankcur=${CURSOR}
       BUFFER="󱉆"
}
postcmd-retrieve() {
       BUFFER="${preyankbuf}"; CURSOR="${preyankcur}"
}
zle -N precmd-lf-yank; zle -N postcmd-retrieve 
bindkey "^[[33~" precmd-lf-yank 
bindkey "^[[34~" postcmd-retrieve 
bindkey -s '^o' '^[[33~^M^[[34~' # ctrl+o to open lf and move easily
bindkey -s -M vicmd '^o' 'i^[[33~^M^[[34~^[l' 

up-line-or-search-ignore-lfcd() {
        zle up-line-or-search; [ "$BUFFER" = "󱉆" ] && zle up-line-or-search
}
zle -N up-line-or-search-ignore-lfcd

down-line-or-search-ignore-lfcd() {
        zle down-line-or-search; [ "$BUFFER" = "󱉆" ] && zle down-line-or-search
}
zle -N down-line-or-search-ignore-lfcd

bindkey "^P" up-line-or-search-ignore-lfcd
bindkey "^N" down-line-or-search-ignore-lfcd
# below in the precmd is the last part of what makes lfcd work

bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n' # use fzf and move there
# make home, end and del work again
bindkey  "^[[H"   vi-beginning-of-line
bindkey  "^[[F"   vi-end-of-line
bindkey -a "^[[H"   vi-beginning-of-line
bindkey -a "^[[F"   vi-end-of-line
bindkey "^u" backward-kill-line

bindkey  "^[[1;5D"   vi-backward-word
bindkey  "^[[1;5C"   vi-forward-word
# make ctrl-left and ctrl-right work (actually on keyboard its bottom control+j/k
bindkey  "^[[H"   vi-beginning-of-line
bindkey  "^[[F"   vi-end-of-line

# standard vi behaviour is a bit different and things like pasted content gets stuck, unable to be deleted with backspace
bindkey -v '^?' backward-delete-char
bindkey -v '^W' backward-delete-word

bindkey -s '^T' 'setsid -f $TERMINAL >/dev/null 2>&1\n'

#Fix delete replacing characters
bindkey "\e[3~" delete-char
# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M visual '^[[P' vi-delete
bindkey -M vicmd '^e' edit-command-line
bindkey -M vicmd 'Y' vi-yank-eol

function precmd {
    if [ -n "$NEED_LFCD_SYNC" ]; then
            LF_INSTANCE_ID="$(cut -d' ' -f1 $LAST_DIR_PATH)"
            dir="$(cut -d' ' -f2- $LAST_DIR_PATH)"
            [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir" 
            unset NEED_LFCD_SYNC
    fi
    # Set window title
    print -Pn "\e]0;zsh%L %(1j,%j job%(2j|s|); ,)%~\e\\"
    print -Pn "\e]133;A\e\\"
}

function preexec {
    # Called when executing a command and sets bar title
    echo -ne '\e[5 q'
    echo -ne "\e]0;${(q)1}\e\\"
}

# capture the signal to allow for easy global terminal colormode switching on every opened terminal
TRAPUSR1() {
  theme=$(< $XDG_RUNTIME_DIR/theme)
  if [ "$theme" = "dark" ];then
    colormodeset
  elif [ "$theme" = "light" ]; then
    colormodeset light
  fi
}

# The following allow for executing a command without deleting the query with Ctrl+Enter 
# if we accept-and-hold in vim's normal more, it comes back to insert mode, this is a function that prevents it
function persistent-normal-edit {
	zle accept-and-hold 
	export ENTERVIAFTER=1
}

zle -N persistent-normal-edit
bindkey '^[[27;5;13~' accept-and-hold
bindkey -M vicmd '^[[27;5;13~' persistent-normal-edit

zle-line-init() { 
	echo -ne '\e[5 q'
	if [ -v ENTERVIAFTER ]; then
		zle -K vicmd
		unset ENTERVIAFTER
	fi 
}
zle -N zle-line-init
autoload -U add-zsh-hook

function osc7-pwd() {
    emulate -L zsh # also sets localoptions for us
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}

function chpwd-osc7-pwd() {
    (( ZSH_SUBSHELL )) || osc7-pwd
}
add-zsh-hook -Uz chpwd chpwd-osc7-pwd

# These colors define how elements on tab completion look like
_ls_colors="di=1;34:ln=3;1;36:so=35:pi=33:ex=1;32:bd=33:cd=33:su=30;41:sg=30;46:tw=30;42:ow=30;43:or=3;1;31" 
zstyle ':completion:*:default' list-colors "${(s.:.)_ls_colors}"
LS_COLORS+=$_ls_colors
export LS_COLORS
export LF_COLORS='.git/=33:*.gitignore=33:*.md=00;38;5;39:*.txt=00;38;5;39:*Makefile=31;1:*Dockerfile=31;1:*.pdf=00;38;5;160:'

function lazy-load {
        # Basic auto/tab complete:
        export FPATH="$FPATH:${HOME}/.local/bin/completions"
        autoload -Uz compinit && compinit
        zstyle ':completion:*' menu select
        zmodload zsh/complist
        _comp_options+=(globdots)		# Include hidden files.

        # Use vim keys in tab complete menu:
        bindkey -M menuselect 'h' vi-backward-char
        bindkey -M menuselect 'k' vi-up-line-or-history
        bindkey -M menuselect 'l' vi-forward-char
        bindkey -M menuselect 'j' vi-down-line-or-history

        if command -v atuin &>/dev/null; then
            eval "$(atuin init zsh)"    
        else
            bindkey '^r' history-incremental-search-backward
            bindkey '^a' history-incremental-search-forward
        fi

        # Load syntax highlighting; should be last.
        source ~/.config/zsh/plugins/vi-motions/motions.zsh
        source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
}

 [ $ZSH_NO_LAZY_LOAD ] || zsh-defer lazy-load
# Start in lfcd requires us to fetch the job number as for whatever reason it doesn't 
# get a referencable job name like usual, so we just fetch the number of the job
if [ $START_IN_LFCD ]; then 
        unset START_IN_LFCD
        󱉆 "${LFCD_FOCUSPATH}"; LFCD_JOB_ID="%${$(jobs)[2]}" 
else 
        LFCD_JOB_ID=lf
fi
