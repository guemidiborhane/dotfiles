function fan --argument level
    set -q level[1]; or return

    echo "level $level" | sudo tee /proc/acpi/ibm/fan
end

# vim ft=fish
