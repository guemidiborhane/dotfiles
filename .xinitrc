#!/bin/sh
#
# LightDM wrapper to run around X sessions.

echo "Running X session wrapper"

# From https://github.com/sddm/sddm/blob/develop/data/scripts/Xsession
# Note that the respective logout scripts are not sourced.
case $SHELL in
*/bash)
	[ -z "$BASH" ] && exec $SHELL --login $0 "$@"
	shopt -q login_shell || exec $SHELL --login $0 "$@"
	set +o posix
	;;
*/zsh)
	[ -z "$ZSH_NAME" ] && exec $SHELL --login $0 "$@"
	[[ -o login ]] || exec $SHELL --login $0 "$@"
	emulate -R sh
	;;
*/csh | */tcsh)
	# [t]cshrc is always sourced automatically.
	# Note that sourcing csh.login after .cshrc is non-standard.
	xsess_tmp=$(mktemp /tmp/xsess-env-XXXXXX)
	$SHELL -c "if (-f /etc/csh.login) source /etc/csh.login; if (-f ~/.login) source ~/.login; /bin/sh -c 'export -p' >! $xsess_tmp"
	. $xsess_tmp
	rm -f $xsess_tmp
	;;
*/fish)
	[ -f /etc/profile ] && . /etc/profile
	[ -f $HOME/.profile ] && . $HOME/.profile
	xsess_tmp=$(mktemp /tmp/xsess-env-XXXXXX)
	$SHELL -c "/bin/sh -c 'export -p' > $xsess_tmp"
	. $xsess_tmp
	rm -f $xsess_tmp
	;;
*) # Plain sh, ksh, and anything we do not know.
	[ -f /etc/profile ] && . /etc/profile
	[ -f "$HOME/.profile" ] && . "$HOME/.profile"
	;;
esac

[ -f /etc/xprofile ] && . /etc/xprofile
[ -f /usr/local/etc/xprofile ] && . /usr/local/etc/xprofile
[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

# Load resources
for file in "/etc/X11/Xresources" "$HOME/.Xresources"; do
	if [ -f "$file" ]; then
		echo "Loading resource: $file"
		xrdb -merge "$file"
	fi
done

# Load keymaps
for file in "/etc/X11/Xkbmap" "$HOME/.Xkbmap"; do
	if [ -f "$file" ]; then
		echo "Loading keymap: $file"
		setxkbmap $(cat "$file")
		XKB_IN_USE=yes
	fi
done

# Load xmodmap if not using XKB
if [ -z "$XKB_IN_USE" ]; then
	for file in "/etc/X11/Xmodmap" "$HOME/.Xmodmap"; do
		if [ -f "$file" ]; then
			echo "Loading modmap: $file"
			xmodmap "$file"
		fi
	done
fi

unset XKB_IN_USE

# Run all system xinitrc shell scripts
xinitdir="/etc/X11/xinit/xinitrc.d"
if [ -d "$xinitdir" ]; then
	for script in $xinitdir/*; do
		echo "Loading xinit script $script"
		if [ -x "$script" -a ! -d "$script" ]; then
			. "$script"
		fi
	done
fi

# Run user xsession shell script
script="$HOME/.xsession"
if [ -x "$script" -a ! -d "$script" ]; then
	echo "Loading xsession script $script"
	. "$script"
fi

echo "X session wrapper complete, running session $@"

. ~/.layouts/main-setup.sh
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

udiskie -s &
exec i3