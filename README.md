# Borhaneddine's dotfiles

## Installation

Using `wget`:

```bash
sh -c "$(wget -qO- https://guemidiborhane.github.io/build_home)"
```

or using `curl`:

```bash
sh -c "$(curl -fsSL https://guemidiborhane.github.io/build_home)"
```

## Commands cheatsheet

### Sign previous commits.
```bash
git filter-branch --commit-filter 'git commit-tree -S "$@";' <COMMIT_HASH>..HEAD
```

### Which process is listening on specific port.
```bash
sudo netstat -nlp | grep :80
```

### Unlock luks.
```bash
echo -ne "SuperSecretPassphrase" > /lib/cryptsetup/passfifo
```

### Kill all zombie processes
```bash
ps -xaw -o state,ppid | grep Z | grep -v PID | awk '{ print $2 }' | xargs kill -9
```

### find vicious PHP files
```bash
find / -type f -regex '.*/*.php' | grep -P '/(?!autoload|settings|personal|mbstring|defaults|translit)([a-z0-9]{8}).php$' > suspicions.txt
```

### Rerun `bundle install` until it succeeds (useful in case of network issues)
```bash
sh -c 'while ! $(bundle check &> /dev/null); do bundle install --retry 10; sleep 1; done'
```

## Useful Links
* [FontAwesome Cheatsheet](https://fontawesome.bootstrapcheatsheets.com/)
