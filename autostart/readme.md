Disabling gnome-keyring-ssh
===========================
    
I want to use ssh-agent key management in my own terminal windows.
Disable gnome-keyring ssh key management with the following line
in a `gnome-keyring-ssh.desktop` file:

    X-GNOME-Autostart-enabled=false

On an Ubuntu box, gpg-agent stepped into the breach instead,
so block that behaviour:

    $ sudo systemctl --global mask gpg-agent-ssh.socket

