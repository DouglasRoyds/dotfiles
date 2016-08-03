# .dotfiles/profile
# Rather than taking over the Ubuntu or Cygwin defaults completely,
# I just have a few of my preferred settings in this file.
# Source me from ~/.profile
# vim: ft=sh

# Ignore case.
# Always accept ANSI characters from tree and source-highlight.
# Stand search targets off the top of the screen by a few lines.
# In .profile, as I also launch less via keyboard shortcuts
export LESS=-iRj5

export EDITOR=/usr/bin/vim

# Start an ssh-agent
# Adapted from Joseph Reagle and Matt Lambie:
# http://www.cygwin.com/ml/cygwin/2001-06/msg00537.html
# http://stackoverflow.com/a/112618
ssh_env=$HOME/.ssh/environment
if [ -f $ssh_env ] ; then
   . $ssh_env > /dev/null
   if ! kill -0 $SSH_AGENT_PID 2>/dev/null; then
      echo "Stale ssh-agent file found. Spawning new agent"
      eval $(ssh-agent | tee $ssh_env)
   fi
else
   echo "Starting ssh-agent"
   eval $(ssh-agent | tee $ssh_env)
fi
chmod 600 $ssh_env

