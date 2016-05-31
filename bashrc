################### Useful aliases
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias l='ls -CF'
alias la='ls -CFA'
alias ld='ls -d'
alias ll='ls -CFlh'
alias lla='ls -CFAlh'
alias ls='ls --color=auto'
alias lx='ls -X'
alias md='mkdir -p'
alias psc='ps xawf -eo pid,user,cgroup,args'


# Setup a red prompt for root and a green one for users.
# rename this file to color_prompt.sh to actually enable it
NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [ "$USER" = root ]; then
	PS1="$RED\h [$NORMAL\w$RED]# $NORMAL"
else
	PS1="$GREEN\h [$NORMAL\w$GREEN]\$ $NORMAL"
fi
