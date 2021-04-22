# Requirements

* [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
* [powerlevel10k](https://github.com/romkatv/powerlevel10k)
* [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
* [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)


# Installation

```bash
  git clone --recursive git@github.com:guemidiborhane/dotfiles.git ~/.dotfiles && cd ~/.dotfiles
  ./install.sh
```

# Useful commands

```bash
# Sign previous commits.
git filter-branch --commit-filter 'git commit-tree -S "$@";' <COMMIT_HASH>..HEAD

# Which process is listening on specific port.
sudo netstat -nlp | grep :80

# Unlock luks.
echo -ne "SuperSecretPassphrase" > /lib/cryptsetup/passfifo

# Kill all zombie processes
ps -xaw -o state,ppid | grep Z | grep -v PID | awk '{ print $2 }' | xargs kill -9

# find vicious PHP files
find / -type f -regex '.*/*.php' | grep -P '/(?!autoload|settings|personal|mbstring|defaults|translit)([a-z0-9]{8}).php$' > suspicions.txt
```

# Useful Links
* [FontAwesome Cheatsheet](https://fontawesome.bootstrapcheatsheets.com/)
 
