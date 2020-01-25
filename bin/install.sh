#!/bin/bash


## var

MY_GIT="${HOME}/git"
MY_VAR="${HOME}/var"
MY_REF="${HOME}/ref"
MY_OLD="${HOME}/old"
MY_FLUTTER="${HOME}/flutter"
PJ_TOP="${MY_GIT}/dotfiles"
PJ_SRC="${PJ_TOP}/src"
if [ -n "${GITHUB_TOKEN}" ]; then
  PJ_GIT="https://${GITHUB_TOKEN}@github.com/itomakiweb-corp/dotfiles.git"
else
  PJ_GIT="https://github.com/itomakiweb-corp/dotfiles.git"
fi


## init

# e: exit if error
# u: throw error if undef
# o pipefail: throw error if pipefail
set -euo pipefail

# options: default skip
doUpdateBrew="false"
doUpdateSettingsScreenshot="false"
doUpdateNvm="false"
doUpdateFlutter="false"
doUpdateFirebase="false"
while [ $# -gt 0 ]; do
  case "${1}" in
    -v|--verbose)
      # display command
      set -x
      ;;
    -a|--all)
      doUpdateBrew="true"
      doUpdateSettingsScreenshot="true"
      doUpdateNvm="true"
      doUpdateFlutter="true"
      doUpdateFirebase="true"
      ;;
    *)
      ;;
  esac
  shift
done


## function

function gitPullOrClone()
{
  local repositoryUrl="${1:?}"
  local repositoryDir="${MY_GIT}/$(echo ${repositoryUrl##*/} | sed 's/.git//g')"

  if [ -d "${repositoryDir}" ]; then
    cd "${repositoryDir}"
    git pull
  else
    mkdir -p "${MY_GIT}"
    cd "${MY_GIT}"
    git clone "${repositoryUrl}"
  fi
}

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

function installNvm()
{
  "${doUpdateNvm}" || return 0

  # install NVM (Node Version Manager)
  # https://github.com/nvm-sh/nvm

  # if use installer, installer append .bashrc
  # https://github.com/nvm-sh/nvm#install--update-script
  #curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash

  # so install manually here
  # https://github.com/nvm-sh/nvm#manual-install
  export NVM_DIR="${HOME}/.config/nvm"
  gitPullOrClone "https://github.com/nvm-sh/nvm.git" "${NVM_DIR}"
  cd "${NVM_DIR}"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
  \. "${NVM_DIR}/nvm.sh"

  # install Node.js + npm (version: LTS = Long Term Support)
  nvm install --lts

  # ref command
  #nvm ls-remote --lts
  #nvm install node # "node" is an alias for the latest version (not LTS like v13.7.0)
  #nvm use --lts
  #nvm alias default v12.14.1

  # install yarn
  # https://yarnpkg.com/ja/docs/install#alternatives-stable
  npm install -g yarn
}

function installFlutter()
{
  "${doUpdateFlutter}" || return 0

  # install Flutter
  # https://flutter.dev/docs/get-started/install/linux
  gitPullOrClone "https://github.com/flutter/flutter.git"
  cd "${MY_FLUTTER}"
  flutter precache
  flutter doctor

  # Enable Web (beta at 20200125)
  # https://flutter.dev/docs/get-started/web
  flutter channel beta
  flutter upgrade
  flutter config --enable-web
  flutter devices

  # ref command
  #flutter create mypj
  #cd mypj
  #flutter run -d chrome
  #flutter build web
}

function installFirebase()
{
  "${doUpdateFirebase}" || return 0

  # install Firebase
  # https://firebase.google.com/docs/cli
  npm install -g firebase-tools

  # ref command
  #firebase login --no-localhost
  #firebase projects:list
}


## main

# get repository
gitPullOrClone "${PJ_GIT}"

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
  if "${doUpdateBrew}"; then
    brew update
    brew upgrade --all
    brew install bash-completion git macvim neovim pstree fzf
    # brew cask install docker google-chrome google-japanese-ime slack atom
    brew doctor
  fi

  # set screencapture
  # https://ichitaso.com/mac/tips-for-os-x-screenshot/
  if "${doUpdateSettingsScreenshot}"; then
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

  installNvm

  installFlutter
  if "${doUpdateFlutter}"; then
    # at 20200125 work arround
    # idevice_id cannot run on catalina #42302
    # https://github.com/flutter/flutter/issues/42302#issuecomment-539852516
    sudo xattr -d com.apple.quarantine ${MY_FLUTTER}/bin/cache/artifacts/libimobiledevice/idevice_id
    sudo xattr -d com.apple.quarantine ${MY_FLUTTER}/bin/cache/artifacts/libimobiledevice/ideviceinfo
    sudo xattr -d com.apple.quarantine ${MY_FLUTTER}/bin/cache/artifacts/usbmuxd/iproxy
  fi

  installFirebase

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

  installNvm

  installFlutter

  installFirebase

  # install Visual Studio Code
  # TODO
  # https://github.com/VSCodeVim/Vim

  # install Android Studio
  # TODO

  # install gatsby
  # https://www.gatsbyjs.org/docs/quick-start
  #npm install -g gatsby-cli

fi

echo "Succeeded."
