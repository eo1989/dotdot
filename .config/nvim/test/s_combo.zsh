#!/usr/bin/env zsh

s_combo() {
    # concat all args into one search query
    local query="$*"
    # define two temp arrays for the providers
    local providers1=(github)
    local providers2=(gist)
    # combine the arrays into one
    local providers=("${providers1[@]}" "${providers2[@]}")

    # optional for debugging, you can print the combined arrays
    # this uses zsh's "power join" to list the elements separated by spaces
    print -r -- "Using providers: $^providers"

    # loop over each provider and run the s command in the background
    for provider in "${providers[@]}"; do
        command s -p "$provider" "$query" &
    done
    # wait for all background jobs to finish
    wait
}

# vim: set ft=zsh ts=8 sw=4 sts=4 et:
