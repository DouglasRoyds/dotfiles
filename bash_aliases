# Symlink me as ~/.bash_aliases

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

alias cal='ncal -bM'
alias ffmpeg='ffmpeg -hide_banner'
alias ls='ls ${color}'
alias pstree='pstree -U'
alias rdesktop='rdesktop -g1920x1060'
alias svnmeld='svn diff --diff-cmd=subversion_meld_wrapper'
alias svnvimdiff='svn diff --diff-cmd=/usr/local/bin/subversion_vimdiff_wrapper'
alias tree='tree -CF --dirsfirst -I .svn -I CVS -I .git -I downloads'

# Silence GTK warnings
alias baobab='baobab 2>/dev/null'
alias eclipse='eclipse 2>/dev/null'
alias eog='eog 2>/dev/null'
alias evince='evince 2>/dev/null'
alias file-roller='file-roller 2>/dev/null'
alias firefox='firefox 2>/dev/null'
alias gimp='gimp 2>/dev/null'
alias gnome-control-center='gnome-control-center 2>/dev/null'
alias libreoffice='libreoffice 2>/dev/null'
alias meld='meld 2>/dev/null'
alias rhythmbox='rhythmbox 2>/dev/null'
alias totem='totem 2>/dev/null'
alias unison='unison 2>/dev/null'
alias x-www-browser='x-www-browser 2>/dev/null'

# Source host-specific aliases
test -r "${HOME}/.bash_aliases_d/$(hostname)" && source "${HOME}/.bash_aliases_d/$(hostname)"

