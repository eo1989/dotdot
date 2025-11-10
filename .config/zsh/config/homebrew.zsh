alias brewfile="brew bundle dump --describe --vscode --mas  --global --force"
# device_name="$(scutil --get ComputerName | cut -d" " -f2-) ($(sw_vers -productVersion))"
device_name="$(/usr/bin/scutil --get ComputerName) ($(sw_vers -productVersion))"

# HOMEBREW_BAT_THEME="Sublime Snazzy" \
export HOMEBREW_BAT=1 \
    HOMEBREW_BAT_CONFIG_PATH="${XDG_CONFIG_HOME}/bat/config" \
    HOMEBREW_BAT_THEME="Dracula" \
    HOMEBREW_CASK_OPTS="--no-quarantine" \
    HOMEBREW_AUTO_UPDATE_SECS=86400 \
    HOMEBREW_CLEANUP_MAX_AGE_DAYS=21 \
    HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS=20 \
    HOMEBREW_NO_ANALYTICS=1 \
    HOMEBREW_NO_ENV_HINTS=1 \
    HOMEBREW_DISPLAY_INSTALL_TIMES=1 \
    HOMEBREW_BUNDLE_FILE_GLOBAL="${HOME}/Brewfile_${device_name}"

function _print-section() {
    echo
    print "\e[1;34m$1\e[0m"
    _separator
}

function recent_bupdates() {
    local count=${1:-10}
    _print-section "Recently updated Formulae"
    brew list -t --formulae | head -n"$count" | rs

    _print-section "Recently updated Casks"
    brew list -t --casks | head -n"$count" | rs
}

function bupdate() {
    _print-section "Homebrew"
    brew update
    brew upgrade
    brew cleanup

    echo
    _print-section "Mac App Store"
    # mas upgrade --HACK--> https://github.com/mas-cli/mas/issues/512
    local mas_updates
    mas_updates=$(mas outdated | grep -vE "Highlights|Mona")
    if [[ -z "${mas_updates}" ]]; then
        echo "No MAS updates."
    else
        echo "${mas_updates}" | cut -f1 -d" " | gxargs mas upgrade
    fi

    # Finish
    # TODO: add logic that checks if sketchybar is installed

    # sketchybar restart for new permission
    # sketchybar_was_updated=$(find "$BREW_PREFIX/bin/sketchybar" -mtime -1h)
    # [[ -n "$sketchybar_was_updated" ]] && brew services restart sketchybar

    # "$ZDOTDIR/notificator" --title "🍺 Homebrew" --message "Update finished." --sound "Blow"
}

function blistall() {
    _print-section "brew info & doctor"
    brew info
    brew doctor

    _print-section "brew services list"
    brew services list

    _print-section "brew taps"
    brew taps

    _print-section "brew leaves --installed-on-request"
    brew leaves --installed-on-request

    _print-section "brew list --casks"
    brew list --casks

    _print-section "Mac App Store"
    mas list

    brew bundle dump --describe --global --vscode --mas --force &>/dev/null &&
        print "\n\0[0;38;5;247mBrewfile saved.\e[0m"
}
