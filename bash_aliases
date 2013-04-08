# Symlink me as ~/.bash_aliases

if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    color='--color=auto'
fi

alias date='date +"%A %d %b %Y %l:%M:%S%p"'
alias egrep="egrep ${color} --exclude-dir=generated --exclude-dir=.svn --exclude=tags -I"
alias grep="grep   ${color} --exclude-dir=generated --exclude-dir=.svn --exclude=tags -I"
alias ls='ls ${color}'
alias nautilus='nautilus --no-desktop 2>/dev/null'
alias rdesktop='rdesktop -g1920x1080'
alias svnmeld='svn diff --diff-cmd=subversion_meld_wrapper'
alias svnvimdiff='svn diff --diff-cmd=/usr/local/bin/subversion_vimdiff_wrapper'
alias tree='tree -CF --dirsfirst -I .svn -I CVS -I .git -I downloads'

# Silence GTK warnings
alias baobab='baobab 2>/dev/null'
alias eclipse='eclipse 2>/dev/null'
alias eog='eog 2>/dev/null'
alias evince='evince 2>/dev/null'
alias file-roller='file-roller 2>/dev/null'
alias gnome-control-center='gnome-control-center 2>/dev/null'
alias meld='meld 2>/dev/null'
alias rhythmbox='rhythmbox 2>/dev/null'
alias totem='totem 2>/dev/null'
alias unison='unison 2>/dev/null'

