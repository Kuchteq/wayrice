# Luke's config for the Zoomer Shell
# Enable colors and change prompt:
set history-preserve-point on
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Yanking is saved to clipboard
function vi-yank-wl {
    zle vi-yank
   echo "$CUTBUFFER" | wl-copy
}
zle -N vi-yank-wl
bindkey -M vicmd 'y' vi-yank-wl

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lfrun -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' '^ulfcd\n' # ctrl+o to open lf and move easily

bindkey -s '^a' '^ubc -lq\n' # open bc calculator

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
	if [ -v ENTERVIAFTER ]; then
		keyd do esc l
	fi
	unset ENTERVIAFTER
}

function preexec {
    # Called when executing a command and sets bar title
    print -Pn "\e]0;${(q)1}\e\\"
}

# capture the signal to allow for easy global terminal colormode switching on every opened terminal
TRAPUSR1() {
  theme=$(< /tmp/theme)
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

# Load syntax highlighting; should be last.
source $XDG_CONFIG_HOME/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
