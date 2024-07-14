export LC_CTYPE=en_US.UTF-8

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# U26A1
export PS1='\[\033[01;31m\]\u\[\033[01;37m\]⚡\[\033[00m\]\[\033[01;31m\]\h\[\033[00m\] \[\033[01;34m\]\W\[\033[00m\]\[\033[01;31m\]\$\[\033[00m\] '

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
alias vboxmanage-cmd="vboxmanage | grep 'VBoxManage' | sed 's/[[<].*//' | sort | uniq"
alias matrix="cmatrix -abs"
alias grep='grep --color'
alias vim='nvim'

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

[ -f $HOME/.bash_aliases ] && source $HOME/.bash_aliases
[ -d $HOME/.bash_tools ] && mkdir -p $HOME/.bash_tools

for tool in $HOME/.bash_tools/*; do source $tool; done

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
export LESS_TERMCAP_mb=$(tput bold; tput setaf 1)
# Begin bold
export LESS_TERMCAP_md=$(tput bold; tput setaf 9)
# End mode
export LESS_TERMCAP_me=$(tput sgr0)
# End standout-mode
export LESS_TERMCAP_se=$(tput sgr0)
# Begin standout-mode - info box
export LESS_TERMCAP_so=$(tput bold; tput setaf 5)
# End underline
export LESS_TERMCAP_ue=$(tput sgr0)
# Begin underline
export LESS_TERMCAP_us=$(tput bold; tput setaf 2)

# Postgres configs
export PGENV_ROOT=$HOME/.local
export PGDATA=$PGENV_ROOT/pgsql/data

# nvm (node and npm installer)
source /usr/share/nvm/init-nvm.sh

# make local executables and libraries visible
include_link_path $HOME/.local/pgsql/bin
include_path $HOME/projects/pgenv/bin
include_path /opt/Qt/Tools/*/bin
include_path /opt/Qt/[5,6]*/gcc_64/bin
include_path /opt/x-tools/*/bin
include_path $HOME/.local/x-tools/*/bin
include_path /opt/clion/latest/bin
include_path $HOME/.local/src/clang+llvm-17.0.6/bin
include_path $HOME/.dotnet/bin
include_path $HOME/.local/bin
include_lib $HOME/.local/lib
include_lib /opt/Qt/*/gcc_64/lib

[ -v TMUX ] || tmux

alias poweroff="(sleep 0.5 && poweroff); kill $(pgrep tmux | xargs)"
alias reboot="(sleep 0.5 && reboot); kill $(pgrep tmux | xargs)"
