function kickoff --argument name
    set template "git@git.netsys.dz:guemidiborhane/kickoff.git"
    set -q name[1]; or return

    if test -d $name
        echo "Directory $name already exists"
        return 1
    end

    git clone --depth 1 $template $name
    cd $name

    sh install.sh
end

# vim ft=fish
