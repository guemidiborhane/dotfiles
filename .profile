export TERMINAL=wezterm
export BROWSER=/usr/bin/firefox

eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

# Added by Toolbox App
export PATH="$PATH:$HOME/.asdf/shims"
