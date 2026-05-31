function compress -d "Create archives with fuzzy format selection"
    if test (count $argv) -lt 2
        echo "Usage: compress <archive_name> <files...>"
        return 1
    end

    set archive_name $argv[1]
    set files $argv[2..-1]

    switch $archive_name
        case "*.tar.gz" "*.tgz"
            tar czf $archive_name $files
        case "*.tar.bz2" "*.tbz2"
            tar cjf $archive_name $files
        case "*.zip"
            zip -r $archive_name $files
        case "*.7z"
            7z a $archive_name $files
        case "*"
            set format (echo -e "tar.gz\ntar.bz2\nzip\n7z" | fzf --prompt="Select format: ")
            if test -n "$format"
                compress "$archive_name.$format" $files
            end
    end
end

# vim ft=fish
