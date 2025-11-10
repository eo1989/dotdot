#!/usr/bin/env bash

fyle="${1/#\~/$HOME}"

if [[ $(file -b "${fyle}") == directory ]]; then
    # tree -C "$file"
    if command -v eza &> /dev/null; then
        eza -la --color=always --icons -g --group-directories-first "${fyle}"
    else
        gls -hFNla --color=always --group-directories-first --hyperlink=auto "${fyle}"
    fi
    exit
fi

mime=$(file --dereference --brief --mime-type "$fyle")

if [[ "${mime}" =~ \-binary ]]; then
    file "$fyle"
    exit
fi

image_previewer() {
    # In Kitty
    # Kitty image protocol works well in both normal terminal and tmux, but not in Neovim's builtin
    # terminal. Tmux is special, it works in tmux pane but fails in tmux popup (ref:
    # https://github.com/junegunn/fzf/issues/3972). My fzf starts in tmux popup when it runs in
    # tmux, so kitty image protocol does not work. In all the situations where kitty image protocol
    # fails to work, use chafa with symbols (ANSI art) format as a workaround.
    #
    # For Ghostty, since it uses the Kitty graphic protocol, we handle image preview in the same way
    # as Kitty.
    #
    if [[ $KITTY_WINDOW_ID || $GHOSTTY_BIN_DIR ]]; then
        # In Kitty or Ghostty
        if [[ ! $TERM =~ "tmux" && -z $NVIM  ]]; then
        # if [[ ! $TERM =~ "tmux" && -z $NVIM && =~ ^image ]]; then
            # Not in tmux and not in neovim's builtin terminal
            kitty +kitten icat --clear --transfer-mode=stream --unicode-placeholder --stdin=no --align left --place="${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))"@0x0 "$1" | sed '$d' | sed $'$s/$/\e[m/'
            # kitty +kitten icat --clear --transfer-mode=file --unicode-placeholder --stdin=no --align left --place="${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))"@0x0 "$1" | sed '$d' | sed $'$s/$/\e[m/'
            # --transfer-mode=memory is the fastest option but if we want fzf to be able to redraw the image
            # on terminal resize or on 'change-preview-window', we need to use --transfer-mode=stream.
        else
            printf "Use Chafa's symbols (ANSI art) format to preview images.\n"
            chafa -f symbols -s "${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))" --animate off --polite on "$1"
        fi
    elif [[ $WEZTERM_PANE || $ALACRITTY_WINDOW_ID ]]; then
        # In Wezterm or Alacritty
        if [[ -z $NVIM ]]; then
            chafa -s "${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))" --animate off --polite on "$1"
        else
            chafa -f symbols -s "${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 1))" --animate off --polite on "$1"
        fi
    else
        echo "Image preview is NOT supported!"
    fi
}

if [[ $mime =~ image/ ]]; then
    echo "Resolution: $(identify -format "%w×%h" "$fyle")"
    image_previewer "$fyle"
    exit
fi

# Video can be previewed by previewing its thumbnail
if [[ $mime =~ video/|audio/ ]]; then
    dimensions=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "${fyle}")
    echo "Dimensions: ${dimensions}"
    thumbnail="$("${HOME}/.config/lf/vidthumb" "${fyle}")"
    image_previewer "${thumbnail}"
    exit
fi

(bat --color=always --style=numbers "${fyle}" \
    || highlight --out-format truecolor --style darkplus --force --line-numbers "${fyle}" \
    || cat "${fyle}") | head -200 \
    || echo -e " No preview supported for the current selection:\n\n ${fyle}"
