# Requirements

* [yadm](https://yadm.io/)

# Installation

```bash
  yadm clone git@github.com/guemidiborhane/dotfiles.git --bootstrap -w ~/.files
```

# Commands cheatsheet

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

# Rerun `bundle install` until it succeeds (useful in case of network issues)
sh -c 'while ! $(bundle check &> /dev/null); do bundle install --retry 10; sleep 1; done'
```

# Useful Links
* [FontAwesome Cheatsheet](https://fontawesome.bootstrapcheatsheets.com/)
