function serve -d "Quick HTTP server"
    set port 8888
    if test (count $argv) -gt 0
        set port $argv[1]
    end

    echo "Serving on http://localhost:$port"
    python -m http.server $port
end

# vim ft=fish
