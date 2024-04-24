export LC_CTYPE=en_US.UTF-8

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PS1='\[\033[01;02;31m\]\u\[\033[01;03;37m\] ♰ \[\033[00m\]\[\033[01;02;31m\]\h\[\033[00m\] \[\033[01;02;34m\]\W\[\033[00m\]\[\033[01;02;31m\]\$\[\033[00m\] '

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# No duplicate commands in history (ignoredups + ignorespace)
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

[ -f /etc/profile.d/vte.sh ] && source /etc/profile.d/vte.sh

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# debian only
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Alias definitions.
alias ls='ls --color=auto'
alias ll='ls -hl --color=auto --group-directories-first'
alias vboxmanage-cmd="vboxmanage | grep 'VBoxManage' | sed 's/[[<].*//' | uniq"
alias matrix="cmatrix -abs"
alias grep='grep --color'
alias vim='nvim'

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

[ -d ~/.bash_tools ] && for tool in ~/.bash_tools/*; do source $tool; done

[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

stty -ixon

# Introduce terminal to GPG
export GPG_TTY=$(tty)
# Default editor for system
export EDITOR=$(type -p nvim)
# Less colors for man pages
export PAGER='/usr/bin/less -S'
# Begin blinking
export LESS_TERMCAP_mb=$(tput setaf 1)
# Begin bold
export LESS_TERMCAP_md=$(tput setaf 9)
# End mode
export LESS_TERMCAP_me=$(tput sgr0)
# End standout-mode
export LESS_TERMCAP_se=$(tput sgr0)
# Begin standout-mode - info box
export LESS_TERMCAP_so=$(tput setaf 5)
# End underline
export LESS_TERMCAP_ue=$(tput sgr0)
# Begin underline
export LESS_TERMCAP_us=$(tput setaf 2)

# Postgres configs
export PGENV_ROOT=/opt/postgresql
export PGDATA=$PGENV_ROOT/pgsql/data

# make local executables and libraries visible
include_path $HOME/.local/bin
include_link_path $HOME/.local/pgsql/bin
include_path /opt/Qt/Tools/*/bin
include_path /opt/Qt/[5,6]*/*/bin
include_path /opt/x-tools/*/bin

