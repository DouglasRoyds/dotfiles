# Symlink me as ~/.bash_aliases

export PROFILES="$PROFILES .bash_aliases"

if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    color='--color=auto'
fi

if echo $TERM | grep -q 256; then
   alias tmux='tmux -2'
fi

# grep is fussy about the order of --include and --exclude[-dir] on the command line.
# grep will not respect a --include that has any --excludes preceding it.
grep_options="--exclude-dir=generated --exclude-dir=.svn --exclude-dir=.git --exclude=tags -I $color"
alias grep="grep $grep_options"
alias egrep="egrep $grep_options"

alias ag="ag --color-match='01;31' --color-path=35 --smart-case"
alias cal='ncal -bM'
alias ffmpeg='ffmpeg -hide_banner'
alias ls='ls ${color}'
alias pstree='pstree -U'
alias rdesktop='rdesktop -g1920x1060'
alias svnmeld='svn diff --diff-cmd=subversion_meld_wrapper'
alias svnvimdiff='svn diff --diff-cmd=/usr/local/bin/subversion_vimdiff_wrapper'
alias tree='tree -CF --dirsfirst --filelimit 80 -I .svn -I CVS -I .git'

# Silence GTK warnings
alias baobab='baobab 2>/dev/null'
alias diffpdf='diffpdf 2>/dev/null'
alias eclipse='eclipse 2>/dev/null'
alias eog='eog 2>/dev/null'
alias evince='evince 2>/dev/null'
alias file-roller='file-roller 2>/dev/null'
alias firefox='firefox 2>/dev/null'
alias gimp='gimp 2>/dev/null'
alias gnome-control-center='gnome-control-center 2>/dev/null'
alias libreoffice='libreoffice 2>/dev/null'
alias meld='meld 2>/dev/null'
alias nautilus='nautilus 2>/dev/null'
alias rhythmbox='rhythmbox 2>/dev/null'
alias totem='totem 2>/dev/null'
alias turtl='turtl 2>/dev/null'
alias unison='unison 2>/dev/null'
alias x-www-browser='x-www-browser 2>/dev/null'

# I keep typing vim commands in my console
not_in_kansas="Toto, I've a feeling we're not in Kansas any more"
alias :wq="echo \"$not_in_kansas\""
alias :qa="echo \"$not_in_kansas\""

# Source host-specific aliases
test -r ~/.bash_aliases.d/$(hostname) && source ~/.bash_aliases.d/$(hostname)
