Bash profiles
=============

 * [Profile files](#profile-files)
 * [Getting a consistent environment](#getting-a-consistent-environment)

Profile files
-------------

Which profile scripts get run when, and in which order? Where do the environment variables come from? The following
examples assume that `~/.profile` and `~/.bash_profile` are both present.

### Launch an executable using Gnome/KDE application launcher

GDM and KDM source the following files during session start-up (see `/etc/gdm/Xsession` or `/etc/kde4/kdm/Xsession`). These
scripts set the environment that is available to all applications launched inside Gnome or KDE using desktop launchers
or the application launcher. Note that KDM will source a `~/.bash_profile` if it exists (so it's generally safest not to
have one):

1. `/etc/profile`
2. `~/.profile`

### Gnome/KDE terminal window with a bash shell

Gnome-terminal and Konsole inherit the session environment (as above), then bash (running as an interactive, non-login
shell) sources `/etc/bash.bashrc` and `~/.bashrc`:

1. `/etc/profile`
2. `~/.profile`
3. `/etc/bash.bashrc`
4. `~/.bashrc`

### TTY login

Running as an interactive login shell, bash sources `/etc/profile`, then the first of `~/.bash_profile`, `~/.bash_login`, or
`~/.profile` that it finds. Ubuntu's `/etc/profile` sources `/etc/bash.bashrc` as well (when running an interactive bash
shell), resulting in:

1. `/etc/profile`
2. `/etc/bash.bashrc`
3. `~/.bash_profile`

### SSH login

Bash runs as an interactive login shell, as above:

1. `/etc/profile`
2. `/etc/bash.bashrc`
3. `~/.bash_profile`

### Launch an executable via SSH

Bash is not launched at all, so nothing is sourced.
If bash is launched explicitly to run the command, it runs non-interactively, and sources nothing.
Any environment that you need should be explicitly sourced, eg:

   $ ssh user@hostname '. /home/user/.profile && env'

### Chroot login

Bash runs as an interactive login shell:

1. `/etc/profile`
2. `/etc/bash.bashrc`
3. `~/.bash_profile`

### su --login

Bash runs as an interactive login shell:

1. `/etc/profile`
2. `/etc/bash.bashrc`
3. `~/.bash_profile`

### Launch an executable via su --login

Bash is started non-interactively to run the command:

1. `/etc/profile`
2. `~/.profile`


Getting a consistent environment
--------------------------------

:warning: These recommendations only apply to an Ubuntu box

:warning: Environment variables will not be set when running an executable via SSH

### Don't use `~/.bash_profile`

Use `~/.profile` instead. This means that `~/.profile` is sourced in every case above (except running an executable via
SSH).

### Put non-interactive settings in `~/.profile`

Notably your desired environment variables (eg. PATH). These environment variables will be available to applications and
scripts that you run from launchers, editors, or IDEs:

    export SVN='http://svnhost.someserver.com:3180/svn'
    export CCACHE_PATH=/home/roydsd/build/tmp/cross/armv5te/bin:$PATH
    export PATH=/home/roydsd/workspace/tools/bin:$PATH

### Put interactive settings in `~/.bashrc`

For instance:

    force_color_prompt=yes
    export EDITOR=/usr/bin/vim
    source ~/.bash_aliases

### Source `~/.bashrc` from `~/.profile`

But only if running an interactive bash shell. Interactive settings (eg. the prompt) will be available for TTY and SSH
logins:

    if [ "$PS1" ]; then
        if [ "$BASH" ]; then
            source ~/.bashrc
        fi
    fi

