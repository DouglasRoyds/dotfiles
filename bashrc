# .dotfiles/bashrc
# Rather than taking over the Ubuntu or Cygwin defaults completely for now,
# I just have a few of my preferred settings in this file.
# Source me from ~/.bashrc

# Only ignore duplicates.
# Keep lines beginning with a space, as that is a common typo (ignorespace)
# Keep a massive history.
HISTCONTROL=ignoredups
HISTSIZE=10000
HISTFILESIZE=10000

# Append to the history file, don't overwrite it
shopt -s histappend

case "$COLORTERM" in
    gnome-terminal)  export TERM=xterm-256color
                     ;;
esac

function prompt_command {
   local trunc_string="..."
   short_pwd="${PWD/$HOME/~}"

   # Remove leading directories beyond a certain length
   # Strip any partial directory names
   local pwdmaxlen=30
   if [ ${#short_pwd} -gt $pwdmaxlen ]; then
      local pwdoffset=$(( ${#short_pwd} - $pwdmaxlen ))
      short_pwd="${short_pwd:$pwdoffset:$pwdmaxlen}"
      short_pwd="${trunc_string}/${short_pwd#*/}"
   fi

   # If this is an xterm set the title to user@host:dir
   case "$TERM" in
   xterm*|rxvt*)
      echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
      ;;
   *)
      ;;
   esac

   if [ -n "$VIMRUNTIME" ]; then
      # When we :sh out of Vim, it's handy to see that we've done so.
      user_host="VIM"
   else
      user_host="${USER}@${HOSTNAME}"
   fi

   # Append to the history file and read from it on every prompt.
   # Combines with my massive HISTSIZE settings above to share history between consoles
   history -a
   history -r
}
export PROMPT_COMMAND=prompt_command

# I only ever use a colour prompt.
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]$user_host\[\033[00m\]:\[\033[01;34m\]$short_pwd\[\033[00m\]\$ '

# Enable the double-star glob pattern, eg. this/**/that
shopt -s globstar

# Ignore case, always accept ANSI characters
export LESS=-ir

# Use the Other True Editor on the command-line
set -o vi
bind -m vi-insert “\C-l”:clear-screen
# TODO: Don't seem to be able to bind to Ctrl-Alt-E
#bind -m vi-insert "\e\C-e":shell-expand-line

# Always dereference $PWD when changing directory via a symlink
set -P

# Disable XON/XOFF flow control (ie. Ctrl-S), so that I can use Ctrl-S as the complement to Ctrl-R
stty -ixon

