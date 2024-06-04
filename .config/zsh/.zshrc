# Luke's config for the Zoomer Shell
# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
set history-preserve-point on
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Basic auto/tab complete:
export FPATH="$FPATH:${HOME}/.local/bin/completions"
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.


# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
echo -ne '\e[5 q' # Use beam shape cursor on startup.

# Yanking is saved to clipboard
function vi-yank-wl {
    zle vi-yank
   echo "$CUTBUFFER" | wl-copy
}
zle -N vi-yank-wl
bindkey -M vicmd 'y' vi-yank-wl

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    echo -e '\e[2F'
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

bindkey -s '^o' '^ulfcd\n' # ctrl+o to open lf and move easily
bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n' # use fzf and move there

# make home, end and del work again
bindkey  "^[[H"   vi-beginning-of-line
bindkey  "^[[F"   vi-end-of-line
bindkey -a "^[[H"   vi-beginning-of-line
bindkey -a "^[[F"   vi-end-of-line

bindkey  "^[[1;5D"   vi-backward-word
bindkey  "^[[1;5C"   vi-forward-word
# make ctrl-left and ctrl-right work (actually on keyboard its bottom control+j/k
bindkey  "^[[H"   vi-beginning-of-line
bindkey  "^[[F"   vi-end-of-line

bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
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
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete


function precmd {
    # Set window title
    print -Pn "\e]0;zsh%L %(1j,%j job%(2j|s|); ,)%~\e\\"
    print -Pn "\e]133;A\e\\"
}
function preexec {
    # Called when executing a command and sets bar title
    echo -ne '\e[5 q'
    print -Pn "\e]0;${(q)1}\e\\"
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
_ls_colors="di=1;34:ln=1;36:so=35:pi=33:ex=1;32:bd=33:cd=33:su=30;41:sg=30;46:tw=30;42:ow=30;43" 
zstyle ':completion:*:default' list-colors "${(s.:.)_ls_colors}"
LS_COLORS+=$_ls_colors

if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh)"    
else
    bindkey '^r' history-incremental-search-backward
    bindkey '^a' history-incremental-search-forward
fi

# Load syntax highlighting; should be last.
[ -f ~/.config/zsh/plugins/vi-motions/motions.zsh ] && source ~/.config/zsh/plugins/vi-motions/motions.zsh
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
