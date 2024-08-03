#!/bin/sh
#
# LightDM wrapper to run around X sessions.

log() {
	echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting X session wrapper"

# Source profile files
source_profiles() {
	for profile in /etc/profile /usr/local/etc/profile "$HOME/.profile"; do
		[ -f "$profile" ] && . "$profile"
	done
}

# Shell-specific initialization
initialize_shell() {
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
		xsess_tmp=$(mktemp /tmp/xsess-env-XXXXXX)
		$SHELL -c "if (-f /etc/csh.login) source /etc/csh.login; if (-f ~/.login) source ~/.login; /bin/sh -c 'export -p' >! $xsess_tmp"
		. $xsess_tmp
		rm -f $xsess_tmp
		;;
	*/fish)
		source_profiles
		xsess_tmp=$(mktemp /tmp/xsess-env-XXXXXX)
		$SHELL -c "/bin/sh -c 'export -p' > $xsess_tmp"
		. $xsess_tmp
		rm -f $xsess_tmp
		;;
	*) # Plain sh, ksh, and anything we do not know.
		source_profiles
		;;
	esac
}

# Source xprofile files
source_xprofile() {
	for xprofile in /etc/xprofile /usr/local/etc/xprofile "$HOME/.xprofile"; do
		[ -f "$xprofile" ] && . "$xprofile"
	done
}

# Load X resources
load_resources() {
	for resource in /etc/X11/Xresources "$HOME/.Xresources"; do
		if [ -f "$resource" ]; then
			log "Loading resource: $resource"
			xrdb -merge "$resource"
		fi
	done
}

# Load keymaps
load_keymaps() {
	for keymap in /etc/X11/Xkbmap "$HOME/.Xkbmap"; do
		if [ -f "$keymap" ]; then
			log "Loading keymap: $keymap"
			setxkbmap $(cat "$keymap")
			XKB_IN_USE=yes
		fi
	done
}

# Load xmodmap if not using XKB
load_modmaps() {
	if [ -z "$XKB_IN_USE" ]; then
		for modmap in /etc/X11/Xmodmap "$HOME/.Xmodmap"; do
			if [ -f "$modmap" ]; then
				log "Loading modmap: $modmap"
				xmodmap "$modmap"
			fi
		done
	fi
}

# Run system xinitrc scripts
run_xinit_scripts() {
	xinitdir="/etc/X11/xinit/xinitrc.d"
	if [ -d "$xinitdir" ]; then
		for script in $xinitdir/*; do
			log "Loading xinit script $script"
			if [ -x "$script" -a ! -d "$script" ]; then
				. "$script"
			fi
		done
	fi
}

# Run user xsession script
run_user_xsession() {
	script="$HOME/.xsession"
	if [ -x "$script" -a ! -d "$script" ]; then
		log "Loading xsession script $script"
		. "$script"
	fi
}

# Run all initialization functions
initialize_shell
source_xprofile
load_resources &
load_keymaps &
load_modmaps &
run_xinit_scripts
run_user_xsession

wait

log "X session wrapper complete, running session $@"

# User-specific initializations
if [ -x "$HOME/.layouts/main-setup.sh" ]; then
	"$HOME/.layouts/main-setup.sh"
fi

# Start dunst notification daemon
dunst --config ~/.config/dunst/dunstrc &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
udiskie -s &
~/.fehbg &

if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
	eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

exec i3
