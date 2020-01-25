## var

### base

#export LANG="ja_JP.UTF-8"
#export LC_ALL="ja_JP.UTF-8"
#export LC_MESSAGES="ja_JP.UTF-8"
export FIGNORE=".svn:.git"
export PAGER="less -+S -M"
export EDITOR="vim"

### history

export HISTSIZE="5000"
export HISTFILESIZE="5000"
export HISTCONTROL="ignoreboth"
#export HISTIGNORE="?:??:???:exit"
export HISTIGNORE="exit"
export HISTTIMEFORMAT="%Y-%m-%d %T "

# share history for multi terminal like screen
shopt -s histappend
shopt -s histreedit
shopt -s histverify
shopt -s cmdhist
shopt -s lithist
PROMPT_COMMAND='history -a; history -c; history -r'

### __git_ps1

# required: brew install bash-completion git
# unstaged (*) and staged (+) changes will be shown next to the branch name.
GIT_PS1_SHOWDIRTYSTATE=1
# If something is stashed, then a '$' will be shown next to the branch name.
GIT_PS1_SHOWSTASHSTATE=1
# If there're untracked files, then a '%' will be shown next to the branch name.
GIT_PS1_SHOWUNTRACKEDFILES=1
# show number of commits ahead/behind (+/-) upstream
GIT_PS1_SHOWUPSTREAM="verbose"

### ps1

##\a     an ASCII bell character (07)
# \d     the date in "Weekday Month Date" format (e.g., "Tue May 26")
##\D{format}
##       the format is passed to strftime(3) ...
##\e     an ASCII escape character (033)
##\h     the hostname up to the first `.'
# \H     the hostname
##\j     the number of jobs currently managed by the shell
# \l     the basename of the shell's terminal device name
# \n     newline
##\r     carriage return
# \s     the name of the shell, the basename of $0 (the portion following the final slash)
##\t     the current time in 24-hour HH:MM:SS format
##\T     the current time in 12-hour HH:MM:SS format
##\@     the current time in 12-hour am/pm format
# \A     the current time in 24-hour HH:MM format
# \u     the username of the current user
##\v     the version of bash (e.g., 2.00)
# \V     the release of bash, version + patch level (e.g., 2.00.0)
# \w     the current working directory, with $HOME abbreviated with a tilde
##\W     the basename of the current working directory, with $HOME abbreviated with a tilde
# \!     the history number of this command
# \#     the command number of this command
# \$     if the effective UID is 0, a #, otherwise a $
##\nnn   the character corresponding to the octal number nnn
##\\     a backslash
##\[     begin a sequence of non-printing characters, which could be used to embed a terminal control sequence into the prompt
##\]     end a sequence of non-printing characters
if [ -s "/usr/local/etc/bash_completion.d/git-prompt.sh" ]; then
  export PS1='\n\d \A \s \V \l \! \#$(__git_ps1)\n\u@\H:\w/\n\$ '
else
  export PS1='\n\d \A \s \V \l \! \#\n\u@\H:\w/\n\$ '
fi

### default

export MY_APP="/Applications"
export MY_DESKTOP="${HOME}/Desktop"
export MY_DOWNLOADS="${HOME}/Downloads"
export MY_DROPBOX="${HOME}/Dropbox"

### self (ref => org)

export MY_OLD="${HOME}/old"
export MY_BIN="${HOME}/bin"
export MY_REF="${HOME}/ref"
export MY_TMP="${HOME}/tmp"
export MY_VAR="${HOME}/var"
export MY_GIT="${HOME}/git"

### configs

export MY_DOTFILES="${MY_GIT}/dotfiles"
export MY_DOTFILES_INSTALL="${MY_DOTFILES}/bin/install.sh"
export MY_DOTFILES_SRC="${MY_DOTFILES}/src"
export MY_CONFIG="${MY_DOTFILES_SRC}/.config"
export MY_SSH="${MY_DOTFILES_SRC}/.ssh"
export MY_BASHRC="${MY_DOTFILES_SRC}/.bashrc"
export MY_VIM="${HOME}/.vim"
export MY_VIMRC="${MY_DOTFILES_SRC}/.vimrc"
export MY_GVIMRC="${MY_DOTFILES_SRC}/.gvimrc"
export MY_VIM_SESSION="${MY_VIM}/session"
export MY_VIM_UNDO="${MY_VIM}/undo"
export MY_VIM_TAGS="${MY_VIM}/tags"
export MY_VIM_TAGS_GIT="${MY_VIM_TAGS}/git"

### develop

export MY_MAIN="${MY_GIT}/next"
export MY_SUB1="${MY_GIT}/bank"
export MY_SUB2="${MY_GIT}/dotfiles"
export MY_SUB3="${MY_GIT}/test"


## alias

### usual

alias o="if [ x${TERM} != xscreen ]; then screen -D -R; fi"
alias ls="ls -G"
# -A: except for . and ..
alias ll="ls -Al"
alias lt="ls -Altr"
alias l="ll"
alias vim="$(if which mvim > /dev/null 2>&1; then e='mvim'; else e='vim'; fi; echo ${e}) -vfp"
alias vi="vim"
# mvim for :set helplang=ja
mvim="${MY_APP}/MacVim.app/Contents/MacOS/Vim"
if [ -f "${mvim}" ]; then
  alias mvim="$mvim"
fi
alias pst="pstree -w -u ${USER}"
alias ymd="date '+%Y%m%d'"

### keyboard top

alias q="cd ${MY_REF}/0"
#     w # default command
alias e="cd ${MY_REF}/5"
alias r="source ${MY_BASHRC}"
alias t="cd ${MY_REF}/sec"

### keyboard middle

alias a="cd ${MY_SUB1}"
alias s="cd ${MY_SUB2}"
alias d="cd ${MY_MAIN}"
alias f="cd ${MY_SUB3}"
#     g # original func grep
alias h="history | tail -n 50"

### keyboard bottom

alias z="cd ${MY_OLD}"
alias x="cd ${MY_TMP}"
alias c="cd ${MY_VAR}"
alias v="\
  vim \
  ${MY_VAR}/{101-$(hostname).txt,100-todo.txt} \
  ${MY_VIMRC} \
  ${MY_SUB1}/README.md \
  ${MY_MAIN}/README.md \
  -c '3tabnext' \
  -c 'vsplit ${MY_BASHRC}' \
  -c 'split ${MY_DOTFILES_INSTALL}' \
  -c 'tablast' \
  -c 'cd ${MY_MAIN}' \
"
alias b="vim -S ${MY_VIM_SESSION}"


## function

### reload

# flutter
function rf()
{
  cd "${MY_GIT}/flutter"
  git pull
}
export -f rf

### shortcut

# make and change directory
function md()
{
  local dir="${1:?}"

  mkdir "${dir}" && cd "${dir}"
}
export -f md

# push config files to another host
function pushRc()
{
  local host="${1:?}"

  scp ${HOME}/{.*rc,.gitconfig} ${host}:${HOME}/
}
export -f pushRc

# git commit with adjustHour
function ci()
{
  local lastArg="${@:$#:1}" # same as "${@:(-1):1}"

  # regexp must not enclose double quote for unescape
  if [[ "${lastArg}" =~ [-+][0-9]+ ]]; then
    local adjustHour="${lastArg}"
    local adjustedDate="$(getDate ${adjustHour})"

    # for Mac
    #GIT_COMMITTER_DATE="${adjustedDate}" git commit --date="${adjustedDate}" -v "${@:0:$#}"

    # for Chrome OS
    GIT_COMMITTER_DATE="${adjustedDate}" git commit --date="${adjustedDate}" -v "${@:1:($#-1)}"
  else
    git commit -v "${@}"
  fi
}
export -f ci

# grep usual
function g()
{
  grep \
    --exclude-dir=".git" \
    --exclude-dir="node_modules" \
    --exclude-dir="vendor" \
    --exclude-dir="ref" \
    --exclude-dir="var" \
    --exclude-dir="tmp" \
    -nR "${@:?}" ${MY_GIT}
}
export -f g

# replace strings
function replace()
{
  local old="${1:?}"
  local new="${2:?}"
  local path="${3:-.}"

  # findなしで、grepの--exclude, --exclude-dirで置き換えられるかもしれない
  find "${path}" \
    -name ".git" -prune -o \
    -name ".nuxt" -prune -o \
    -name ".firebase" -prune -o \
    -name "node_modules" -prune -o \
    -name "vendor" -prune -o \
    -name "public" -prune -o \
    -name "dist" -prune -o \
    -name "artifacts" -prune -o \
    -name "ref" -prune -o \
    -name "var" -prune -o \
    -name "tmp" -prune -o \
    -name "*.lock" -prune -o \
    -name "package-lock.json" -prune -o \
    -name "LICENSE" -prune -o \
    -type f -print0 | \
    xargs -0 grep -l --null "${old}" | \
    xargs -0 perl -i -ple "s/${old}/${new}/g"
}
export -f replace

# generate ctags
function genTagGit()
{
  ctags -R \
    --regex-php="/\s*const\s+(\w+)/\1/d/" \
    --exclude=".git" \
    --exclude="node_modules" \
    --exclude="vendor" \
    --exclude="ref" \
    --exclude="var" \
    --exclude="tmp" \
    -f "${MY_VIM_TAGS_GIT}" "${MY_GIT}"
}
export -f genTagGit


## env

uname="$(uname -a)"

### Windows

if [[ "${uname}" =~ "MINGW" ]]; then
  :

### Mac

elif [[ "${uname}" =~ "Darwin" ]]; then
  # maximizing window
  printf '\e[9;1t'

  function getDate()
  {
    local adjustHour="${1:?}"

    date -v${adjustHour}H '+%Y-%m-%dT%H:%M:%S'
  }
  export -f getDate

### Linux

elif [[ "${uname}" =~ "Linux" ]]; then
  alias ls="ls --color"

  function getDate()
  {
    local adjustHour="${1:?}"

    date --date "${adjustHour} hours" '+%Y-%m-%dT%H:%M:%S'
  }
  export -f getDate

fi


## main

### cd

if [ -d "${MY_MAIN}" -a "${PWD}" = "${HOME}" ]; then
  d
fi
