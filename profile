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
export ANSIBLE_NOCOWS=1

# Start an ssh-agent
# Adapted from Joseph Reagle and Matt Lambie:
# http://www.cygwin.com/ml/cygwin/2001-06/msg00537.html
# http://stackoverflow.com/a/112618
agent_pid_is_correct=false
ssh_env=$HOME/.ssh/environment
if [ -f $ssh_env ] ; then
   . $ssh_env > /dev/null
   if pgrep ssh-agent | grep -q $SSH_AGENT_PID; then
      agent_pid_is_correct=true
   fi
fi

if ! $agent_pid_is_correct; then
   echo "Starting ssh-agent"
   eval $(ssh-agent | tee $ssh_env)
   chmod 600 $ssh_env
fi

