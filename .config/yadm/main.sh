#!/bin/sh
# vim: set ft=sh sw=4 et :

# Source all scripts in .config/yadm/bootstrap.d
for script in $HOME/.config/yadm/bootstrap.d/*.sh; do
    if [ -f "$script" ]; then
        . $script
    fi
done

main() {
    echo "Bootstrapping"
    ask_run_all_scripts                                 # scripts/misc.sh
    section "Miscellaneous"                             # scripts/misc.sh
    enable_system_services "${enabled_system_services}" # scripts/system.sh
    enable_user_services "${enabled_user_services}"     # scripts/misc.sh
    configure_resolvconf                                # scripts/system.sh
    configure_backlight                                 # scripts/system.sh
    configure_docker                                    # scripts/misc.sh
    local_bin_permissions                               # scripts/misc.sh
    yadm alt
    configure_polybar # scripts/polybar.sh
    readme            # scripts/misc.sh
}

if [ "$UPDATE" = "yes" ]; then
    section "dotfiles"
    echo "WARNING: This will reset any uncommited changes"
    echo "check for any changes with 'yadm status'"
    echo
    ask_run_all_scripts # scripts/misc.sh
    ask "Reset dotfiles to remote"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        branch=$(yadm rev-parse --abbrev-ref HEAD)
        yadm fetch
        yadm reset --hard "origin/$branch"
        yadm alt
    fi
    ask "Update packages"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        . $HOME/.config/yadm/packages.d/sync-packages
    fi
else
    main
fi
