function mkf -d "Fuzzy make target selection"
    if test -f Makefile
        set target (make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);for(i in A)print A[i]}' | sort -u | fzf)
        if test -n "$target"
            make $target
        end
    else
        echo "No Makefile found"
    end
end

# vim ft=fish
