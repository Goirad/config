
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# prevent common command from polluting history
HISTIGNORE='fg:fg *:j:gdm:gs'

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

# Prints pwd but replaces some prefixes with shorthands
pwd_with_special() {
    local specials=(
    )
    local present="$(dirs +0)"

    for special in "${specials[@]}"; do
        if [[ $present =~ $special* ]]; then
            present="${present#$special}"
            present="$(basename "$special")$present"
            break # stop on first match
        fi
    done
    echo "$present"
}

__prompt_command() {
    local EXIT="$?" # This needs to be first
    EXIT=$(printf '%3d' $EXIT)

    local RCol='\[\e[m\]' # Stop color

    local Cya='\[\e[1;36m\]' # Default
    local Red='\[\e[1;31m\]'

    PS1="${Cya}$(date +'%H:%M:%S') ${RCol}"

    if [ $EXIT != 0 ]; then
        PS1+="${Red}$EXIT ${RCol}" # Add red if exit code non 0
    else
        PS1+="${Cya}$EXIT ${RCol}" # Could be skipped, but might be nice if searching
                                   # through console output (eg $ awk '$2 != 0')
    fi

    PS1+="${Cya}$(pwd_with_special)$ ${RCol}"
}

unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -ahl'
alias la='ls -A'
alias l='ls -CF'

alias t='task'
postpone() {
    # postpones a task
    local task="$1"
    local current_v="$(task $task 2>/dev/null | grep '^Tags' | grep -o 'v[0-9]\.[0-9]\+')"
    if [ -z "$current_v" ]; then
        echo "No version tag found on task $task"
        return 1
    fi

    local v_major="$(echo "$current_v" | cut -d. -f1)"
    local v_minor="$(echo "$current_v" | cut -d. -f2)"
    local next_v_minor=$((v_minor + 1))
    local next_v="$v_major.$next_v_minor"
    task "$task" modify "-$current_v" "+$next_v"
}

# git convenience aliases
alias glo='git log --oneline -n 20 --graph'
alias gap='git add --patch'
alias gca='git commit --amend'
alias gdms='git diff master --stat'
alias gdm='git diff master'
alias gd='git diff'
alias gds='git diff --stat'
alias gdp='git diff "$(git parent 2>/dev/null)"'
alias gdps='git diff "$(git parent 2>/dev/null)" --stat'
alias gs='git status'
alias gsu='git status -uno'
alias gc='git checkout'

alias v="~/oss/nvim.appimage"
alias sv='sudo ~/oss/nvim.appimage'

# creates a new console window in the same directory as the current session
alias sp='alacritty & disown'
alias j='jobs'

# cargo convenience
alias cb='cargo build'
alias cr='cargo run'
alias cbr='cargo build --release'
alias crr='cargo run --release'

alias ..='cd ../'
alias ...='cd ../../'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export TERM=xterm-256color
export PS1="\[\e[0;36m\]\u@\h \w\$ \[\e[m\]"
export PATH=$PATH:~/scripts:~/go/bin
export PAGER=less

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export EDITOR=nvim

