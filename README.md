## install

1. You can get GITHUB_TOKEN from this link(require "repo" check).
    - https://github.com/settings/tokens

```
# Settings about Bash/Screen/SSH/Git/Vim/VS Code/Android Studio/etc with installer.😊
export GITHUB_TOKEN="" # optional your token here
bash -c "$(curl -s https://raw.githubusercontent.com/itomakiweb-corp/dotfiles/master/bin/install.sh)" -- -v -a
source "${HOME}/.bash_profile"
```


## update

```
# only dotfiles
up -v

# include apps
up -v -a
```
