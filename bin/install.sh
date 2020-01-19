#!/bin/bash


## var

MY_GIT="${HOME}/git"
MY_VAR="${HOME}/var"
MY_REF="${HOME}/ref"
MY_OLD="${HOME}/old"
PJ_TOP="${MY_GIT}/dotfiles"
PJ_SRC="${PJ_TOP}/src"
PJ_GIT="git@github.com:itomakiweb-corp/dotfiles.git"


## init

# e: exit if error
# u: throw error if undef
# o pipefail: throw error if pipefail
set -euo pipefail

# display command
set -x

# default skip
# TODO use getopt etc
skipBrew="${1:---skip-brew}"
skipSs="${2:---skip-ss}"


## function

function symbolicLink()
{
  local dir="${1:?}"
  local targetBase="${2:?}"

  ls -A "${dir}" | while read path; do
    [[ "${path}" == ".git" ]] && continue
    [[ "${path}" == ".DS_Store" ]] && continue

    local targetPath="${targetBase}/${path}"

    if [ -d "${dir}/${path}" ]; then
      mkdir -p "${targetPath}"
      symbolicLink "${dir}/${path}" "${targetPath}"
    else
      ln -sfnv "${dir}/${path}" "${targetPath}"
    fi
  done
}


## main

# git pull or clone
if [ -d "${PJ_TOP}" ]; then
  cd "${PJ_TOP}"
  git pull
else
  mkdir -p "${MY_GIT}"
  cd "${MY_GIT}"
  git clone "${PJ_GIT}"
fi

# set symbolicLink
symbolicLink "${PJ_SRC}" "${HOME}"


## env

uname="$(uname -a)"

### Windows

if [[ "${uname}" =~ "MINGW" ]]; then
  :

### Mac

elif [[ "${uname}" =~ "Darwin" ]]; then

  # install brew
  if which brew; then
    :
  else
    # https://brew.sh/index_ja
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # update brew
  if [[ "${skipBrew}" != "--skip-brew" ]]; then
    brew update
    brew upgrade --all
    brew install bash-completion git macvim neovim pstree fzf
    brew cask install docker # google-chrome google-japanese-ime slack atom
    brew doctor
  fi

  # set screencapture
  if [[ "${skipSs}" != "--skip-ss" ]]; then
    # https://ichitaso.com/mac/tips-for-os-x-screenshot/

    defaults write com.apple.screencapture location "${MY_VAR}"
    defaults write com.apple.screencapture name "$(hostname)"
    defaults write com.apple.screencapture include-date -bool true
    defaults write com.apple.screencapture type png

    defaults read com.apple.screencapture
    # defaults delete com.apple.screencapture

    ymd=$(date '+%Y%m%d')
    defaults export com.apple.screencapture "${MY_VAR}/${ymd}-screencapture.plist"
    # defualts import com.apple.screencapture "${MY_VAR}/${ymd}-screencapture.plist"

    killall SystemUIServer
  fi

### Linux

elif [[ "${uname}" =~ "Linux" ]]; then

  # update os
  #sudo apt update
  #sudo apt upgrade

  # mkdir
  mkdir -p "${MY_OLD}"
  ln -sfnv "/mnt/chromeos/MyFiles/Downloads" "${MY_REF}"
  ln -sfnv "/mnt/chromeos/GoogleDrive/MyDrive/z01-private01-docs" "${MY_VAR}"

  # install Screen
  sudo apt install screen

  # install Japanese IME
  # https://www.axon.jp/entry/2018/10/18/201812
  #sudo apt install fonts-noto-cjk
  #sudo apt install fcitx # optional
  #sudo apt install fcitx-mozc
  #sudo apt install fcitx-lib* # optional
  #im-config # optional
  #fcitx-autostart
  #fcitx-configtool
  # select "+", unselect "Only Show Current Language", Search"Mozc"
  # select "Global Config" # optional

  # install Visual Studio Code
  # TODO
  # https://github.com/VSCodeVim/Vim

  # install Android Studio
  # TODO

  # install Flutter
  # TODO

  # install Node Version Manager (LTS Node.js + npm)
  # TODO change to use manual install because installer overwrite bashrc
  #curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash
  #nvm install --lts
  #nvm alias default v12.14.1

  # install yarn
  # https://yarnpkg.com/ja/docs/install#alternatives-stable
  npm install -g yarn

  # install gatsby
  # https://www.gatsbyjs.org/docs/quick-start
  npm install -g gatsby-cli

fi

echo "Succeeded."
