#
# ~/.bashrc
#
# shellcheck disable

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\[\e[32;1m\]\u@\h \[\e[34;1m\]\W\$\[\e[0m\] '

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

source /etc/profile.d/vte.sh

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

[ -d ~/.bash_tools ] && for tool in ~/.bash_tools/*; do source $tool; done

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

stty -ixon

# Introduce terminal to GPG
export GPG_TTY=$(tty)
# Default editor for system
export EDITOR=$(type -p nvim)
# Less colors for man pages
export PAGER=less
# Begin blinking
LESS_TERMCAP_mb=$(tput setaf 1)
# Begin bold
LESS_TERMCAP_md=$(tput setaf 9)
# End mode
LESS_TERMCAP_me=$(tput sgr0)
# End standout-mode
LESS_TERMCAP_se=$(tput sgr0)
# Begin standout-mode - info box
LESS_TERMCAP_so=$(tput setaf 5)
# End underline
LESS_TERMCAP_ue=$(tput sgr0)
# Begin underline
LESS_TERMCAP_us=$(tput setaf 2)

# Postgres root directory
#export PGENV_ROOT=/opt/postgresql
# Database location
#export PGDATA=$PGENV_ROOT/pgsql/data

# ldconfig configurations
#grep -qv "glfw" <<< "$LD_LIBRARY_PATH" && export LD_LIBRARY_PATH="$HOME/packages/glfw/install/lib$([ -n "$LD_LIBRARY_PATH" ] && echo ":$LD_LIBRARY_PATH";)"
#grep -qv '.local' <<< "$LD_LIBRARY_PATH" && export LD_LIBRARY_PATH="$HOME/.local/lib${LD_LIBRARY_PATH:+:}${LD_LIBRARY_PATH}"

# make local executables visible
grep -qv "$(readlink -f "$HOME/.local/bin")" <<< "$PATH" && PATH="$(readlink -f "$HOME/.local/bin")$([ -n "$PATH" ] && echo ":$PATH")"

grep -qv "$(readlink -f "$HOME/.local/pgsql/bin")" <<< "$PATH" && PATH="$(readlink -f "$HOME/.local/pgsql/bin")$([ -n "$PATH" ] && echo ":$PATH")"

# make toolchains executables visible
if [[ -d $HOME/projects/rpizero ]]
then
    for toolchain in $HOME/projects/rpizero
    do
        unset toolchain_path
        toolchain_path="$(readlink -f "$toolchain"/x-tools/**/bin)"

        if grep -vq "${toolchain_path:-x-tools}" <<< "$PATH"
        then
            PATH="${toolchain_path}${toolchain_path:+:}$PATH"
        fi
    done
fi

[ -s ~/.config/proxy.conf ] && source ~/.config/proxy.conf

# Aliases
alias ls='ls --color=auto'
alias ll='ls -hl --color=auto --group-directories-first'
alias vboxmanage-cmd="vboxmanage | grep 'VBoxManage' | sed 's/[[<].*//' | uniq"
alias matrix="cmatrix -abs"
alias grep='grep --color'
alias vim='nvim'

dologin
