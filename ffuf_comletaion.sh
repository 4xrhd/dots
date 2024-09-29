#!/bin/bash

_ffuf_complete() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    opts="
        -H -X -b -d -ignore-body -r -recursion -recursion-depth 
        -recursion-strategy -replay-proxy -timeout -u -x
        -V -ac -acc -c -config -maxtime -maxtime-job -p -rate -s 
        -sa -se -sf -t -v
        -mc -ml -mr -ms -mw
        -fc -fl -fr -fs -fw
        -D -e -ic -input-cmd -input-num -input-shell 
        -mode -request -request-proto -w
        -debug-log -o -od -of -or
    "

    # Auto-complete based on the previous argument
    case "${prev}" in
        -u|-x|-w|-H|-d|-b|-replay-proxy|-config|-debug-log|-o|-od|-request|-input-cmd)
            COMPREPLY=($(compgen -f -- "${cur}"))
            return 0
            ;;
        -t|-rate|-maxtime|-maxtime-job|-timeout|-recursion-depth|-input-num)
            COMPREPLY=($(compgen -W "1 10 20 30 40 50" -- "${cur}"))
            return 0
            ;;
        -recursion-strategy)
            COMPREPLY=($(compgen -W "default greedy" -- "${cur}"))
            return 0
            ;;
        -mode)
            COMPREPLY=($(compgen -W "clusterbomb pitchfork" -- "${cur}"))
            return 0
            ;;
        -of)
            COMPREPLY=($(compgen -W "json ejson html md csv ecsv all" -- "${cur}"))
            return 0
            ;;
        -mc|-fc)
            COMPREPLY=($(compgen -W "200 204 301 302 307 401 403 405 all" -- "${cur}"))
            return 0
            ;;
    esac

    # Default option completion
    COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
    return 0
}

# Register the completion function for ffuf
complete -F _ffuf_complete ffuf

