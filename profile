# .dotfiles/profile
# Rather than taking over the Ubuntu or Cygwin defaults completely,
# I just have a few of my preferred settings in this file.
# Source me from ~/.profile
# vim: ft=sh

export PROFILES="$PROFILES dotfiles/profile"

# Git bash for Windows doesn't provide a .profile at all.
# I have copied over the default Ubuntu .profile,
# and set it to always source .bashrc.
# It also neither sets $USER nor changes to $HOME
test -z "$USER" && export USER=$(basename $HOME)
cd

# Ubuntu now uses pam_umask by default, so no need to set it here.
# pam_umask is smart enough to leave the umask at 0002 if your user and group ID
# are the same, and the username and primary group name are the same.
# See https://blueprints.launchpad.net/ubuntu/+spec/umask-to-0002
# Unfortunately, WSL doesn't use pam.
if uname -r | grep -q Microsoft; then
   umask 0002
fi

# Ignore case.
# Always accept ANSI characters from tree and source-highlight.
# Stand search targets off the top of the screen by a few lines.
# In .profile, as I also launch less via keyboard shortcuts
export LESS=-iRj5

export EDITOR=/usr/bin/vim
export ANSIBLE_NOCOWS=1

## I'm using gdm3, which starts gnome-keyring-daemon automatically at login.
## We just need to set the SSH_AUTH_SOCK variable correctly in terminals.
#if echo "$DESKTOP_SESSION" | egrep -qx "i3|sway.*"; then
#   export $(gnome-keyring-daemon --start)
#fi
