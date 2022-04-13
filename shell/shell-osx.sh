# Some stuff from osx oh-my-zsh config
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/osx/osx.plugin.zsh

### Unified operating system package manager commands

alias myipwlan=ipconfig getifaddr en1
alias myiplan=ipconfig getifaddr en0

# Commentary:
# This additional alias is for public IP, but it's defined in cross platform shared config file shell-common.sh defining common functions for both Linux and Mac. 
# TODO Re-write for setting up on higher level script using ismac islinux switch case
# alias myip=myip='curl -s checkip.dyndns.org | sed -e '\''s/.*Current IP Address: //'\'' -e '\''s/<.*$//'\'

export PATH="$PATH:$HOME/dotfiles/osx/bin"

# PostgreSQL 
alias pgup="pg_ctl -D /usr/local/var/postgres start"
alias pgdown="pg_ctl -D /usr/local/var/postgres stop"

alias o="open ."
alias lsblk="diskutil list"
alias lsusb="system_profiler SPUSBDataType"

# alias pfp="abspath"
# alias cbfp=""
alias cbssh="cat ~/.ssh/id_rsa.pub|"pbcopy
alias efd="cdf && ec ."

# alias sano="say -v \"Mikko\""
alias sano="say -v \"Satu\""
alias sega="say -v \"Oskar\""

alias lsblk="diskutil list"
alias lsusb="system_profiler SPUSBDataType"
alias cb="pbcopy"
alias cbwd="pwd|pbcopy"

alias ai="brew install"
alias ar="brew uninstall"
alias as="brew search"
alias cask="brew cask"
alias aii="brew install --cask"
alias ass="brew cask search"
alias aup="brew update"
alias aug="brew upgrade"


alias fixui="killall -KILL Dock"
alias fixui!="sudo killall -HUP WindowServer"

function pfd() {
    osascript 2>/dev/null <<EOF
    tell application "Finder"
      return POSIX path of (target of window 1 as alias)
    end tell
EOF
}


function pfs() {
    osascript 2>/dev/null <<EOF
    set output to ""
    tell application "Finder" to set the_selection to selection
    set item_count to count the_selection
    repeat with item_index from 1 to count the_selection
      if item_index is less than item_count then set the_delimiter to "\n"
      if item_index is item_count then set the_delimiter to ""
      set output to output & ((item item_index of the_selection as alias)'s POSIX path) & the_delimiter
    end repeat
EOF
}

function cdf() {
    cd "$(pfd)"
}

function pushdf() {
    pushd "$(pfd)"
}

function quick-look() {
    (( $# > 0 )) && qlmanage -p $* &>/dev/null &
}

function man-preview() {
    man -t "$@" | open -f -a Preview
}

function vncviewer() {
    open vnc://$@
}

source $HOME/dotfiles/shell/shell-common.sh
