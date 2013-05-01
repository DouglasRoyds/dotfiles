# .dotfiles/profile
# Rather than taking over the Ubuntu or Cygwin defaults completely,
# I just have a few of my preferred settings in this file.
# Source me from ~/.profile

# The default umask is set in /etc/profile
# To set the umask for ssh logins, install and configure the libpam-umask package.
# I prefer 664 for new files over the default 644.
umask 0002

# Ignore case
# Always accept ANSI characters from tree and source-highlight
# In .profile, as I also launch less via keyboard shortcuts
export LESS=-iR

export EDITOR=/usr/bin/vim

