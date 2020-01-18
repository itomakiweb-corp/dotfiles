## function

### load

function load()
{
  local file="${1:?}"

  if [ -s "${file}" ]; then
    . "${file}"
  else
    echo "cannot load ${file}"
  fi
}
export -f load


## env

uname="$(uname -a)"

### Windows

if [[ "${uname}" =~ "MINGW" ]]; then
  :

### Mac

elif [[ "${uname}" =~ "Darwin" ]]; then

  # Public
  load "/etc/bashrc"

  # required: brew install bash-completion git
  # then can use:
  #  less /usr/local/etc/bash_completion.d/git-completion.bash
  #  less /usr/local/etc/bash_completion.d/git-prompt.sh
  load "/usr/local/etc/bash_completion"

  # Flutter
  # https://flutter.dev/docs/get-started/install/macos
  export PATH="${HOME}/git/flutter/bin:${PATH}"

  # Node Version Manager
  # https://github.com/creationix/nvm
  export NVM_DIR="${HOME}/.config/nvm"
  load "${NVM_DIR}/nvm.sh"
  load "${NVM_DIR}/bash_completion"

  # Android Studio
  # https://docs.expo.io/versions/v33.0.0/workflow/android-studio-emulator/
  export ANDROID_SDK="${HOME}/Library/Android/sdk"
  export PATH="${ANDROID_SDK}/platform-tools:${PATH}"

  # Anaconda3
  # https://www.anaconda.com/download/
  export PATH="/anaconda3/bin:${PATH}"

### Linux

elif [[ "${uname}" =~ "Linux" ]]; then

  # Flutter
  # https://flutter.dev/docs/get-started/install/linux
  export PATH="${HOME}/git/flutter/bin:${PATH}"

  # Node Version Manager
  # https://github.com/nvm-sh/nvm
  export NVM_DIR="${HOME}/.config/nvm"
  load "${NVM_DIR}/nvm.sh"
  load "${NVM_DIR}/bash_completion"

fi


## main

# Private
export XDG_CONFIG_HOME="${HOME}/.config"

# disable <C-s> stop terminal
stty stop undef

# directory: 755, file: 644
umask 0022

export PATH="${HOME}/bin:${PATH}"

load "${HOME}/.bashrc"
