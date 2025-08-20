function extract -d "Universal archive extractor"
    for file in $argv
        switch $file
            case "*.tar.gz" "*.tgz"
                tar xzf $file
            case "*.tar.bz2" "*.tbz2"
                tar xjf $file
            case "*.zip"
                unzip $file
            case "*.rar"
                unrar x $file
            case "*.7z"
                7z x $file
            case "*"
                echo "Unsupported format: $file"
        end
    end
end

# vim ft=fish
