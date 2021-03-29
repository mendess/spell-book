#!/bin/bash
# nmcli(1) completion

# Initialize completion and deal with various general things: do file
# and variable completion where appropriate, and adjust prev, words,
# and cword as if no redirections exist so that completions do not
# need to deal with them.  Before calling this function, make sure
# cur, prev, words, and cword are local, ditto split if you use -s.
#
# Options:
#     -n EXCLUDE  Passed to _get_comp_words_by_ref -n with redirection chars
#     -e XSPEC    Passed to _filedir as first arg for stderr redirections
#     -o XSPEC    Passed to _filedir as first arg for other output redirections
#     -i XSPEC    Passed to _filedir as first arg for stdin redirections
#     -s          Split long options with _split_longopt, implies -n =
# @return  True (0) if completion needs further processing,
#          False (> 0) no further processing is necessary.
#
_init_completion() {
    local exclude="" flag outx errx inx OPTIND=1

    while getopts "n:e:o:i:s" flag "$@"; do
        case $flag in
            n) exclude+=$OPTARG ;;
            e) errx=$OPTARG ;;
            o) outx=$OPTARG ;;
            i) inx=$OPTARG ;;
            s)
                split=false
                exclude+==
                ;;
            *)
                echo "bash_completion: $FUNCNAME: usage error" >&2
                return 1
                ;;
        esac
    done

    COMPREPLY=()
    local redir="@(?([0-9])<|?([0-9&])>?(>)|>&)"
    _get_comp_words_by_ref -n "$exclude<>&" cur prev words cword

    # Complete variable names.
    _variables && return 1

    # Complete on files if current is a redirect possibly followed by a
    # filename, e.g. ">foo", or previous is a "bare" redirect, e.g. ">".
    # shellcheck disable=SC2053
    if [[ $cur == $redir* || ${prev-} == $redir ]]; then
        local xspec
        case $cur in
            2'>'*) xspec=${errx-} ;;
            *'>'*) xspec=${outx-} ;;
            *'<'*) xspec=${inx-} ;;
            *)
                case $prev in
                    2'>'*) xspec=${errx-} ;;
                    *'>'*) xspec=${outx-} ;;
                    *'<'*) xspec=${inx-} ;;
                esac
                ;;
        esac
        cur="${cur##$redir}"
        _filedir $xspec
        return 1
    fi

    # Remove all redirections so completions don't have to deal with them.
    local i skip
    for ((i = 1; i < ${#words[@]}; )); do
        if [[ ${words[i]} == $redir* ]]; then
            # If "bare" redirect, remove also the next word (skip=2).
            # shellcheck disable=SC2053
            [[ ${words[i]} == $redir ]] && skip=2 || skip=1
            words=("${words[@]:0:i}" "${words[@]:i+skip}")
            ((i <= cword)) && ((cword -= skip))
        else
            ((i++))
        fi
    done

    ((cword <= 0)) && return 1
    prev=${words[cword - 1]}

    [[ ${split-} ]] && _split_longopt && split=true

    return 0
}

# This function splits $cur=--foo=bar into $prev=--foo, $cur=bar, making it
# easier to support both "--foo bar" and "--foo=bar" style completions.
# `=' should have been removed from COMP_WORDBREAKS when setting $cur for
# this to be useful.
# Returns 0 if current option was split, 1 otherwise.
#
_split_longopt()
{
    if [[ $cur == --?*=* ]]; then
        # Cut also backslash before '=' in case it ended up there
        # for some reason.
        prev="${cur%%?(\\)=*}"
        cur="${cur#*=}"
        return 0
    fi

    return 1
}

# This function performs file and directory completion. It's better than
# simply using 'compgen -f', because it honours spaces in filenames.
# @param $1  If `-d', complete only on directories.  Otherwise filter/pick only
#            completions with `.$1' and the uppercase version of it as file
#            extension.
#
_filedir()
{
    local IFS=$'\n'

    _tilde "${cur-}" || return

    local -a toks
    local reset arg=${1-}

    if [[ $arg == -d ]]; then
        reset=$(shopt -po noglob)
        set -o noglob
        toks=($(compgen -d -- "${cur-}"))
        IFS=' '
        $reset
        IFS=$'\n'
    else
        local quoted
        _quote_readline_by_ref "${cur-}" quoted

        # Munge xspec to contain uppercase version too
        # https://lists.gnu.org/archive/html/bug-bash/2010-09/msg00036.html
        # news://news.gmane.io/4C940E1C.1010304@case.edu
        local xspec=${arg:+"!*.@($arg|${arg^^})"} plusdirs=()

        # Use plusdirs to get dir completions if we have a xspec; if we don't,
        # there's no need, dirs come along with other completions. Don't use
        # plusdirs quite yet if fallback is in use though, in order to not ruin
        # the fallback condition with the "plus" dirs.
        local opts=(-f -X "$xspec")
        [[ $xspec ]] && plusdirs=(-o plusdirs)
        [[ ${COMP_FILEDIR_FALLBACK-} || -z ${plusdirs-} ]] ||
            opts+=("${plusdirs[@]}")

        reset=$(shopt -po noglob)
        set -o noglob
        toks+=($(compgen "${opts[@]}" -- $quoted))
        IFS=' '
        $reset
        IFS=$'\n'

        # Try without filter if it failed to produce anything and configured to
        [[ -n ${COMP_FILEDIR_FALLBACK-} && -n $arg && ${#toks[@]} -lt 1 ]] && {
            reset=$(shopt -po noglob)
            set -o noglob
            toks+=($(compgen -f ${plusdirs+"${plusdirs[@]}"} -- $quoted))
            IFS=' '
            $reset
            IFS=$'\n'
        }
    fi

    if ((${#toks[@]} != 0)); then
        # 2>/dev/null for direct invocation, e.g. in the _filedir unit test
        compopt -o filenames 2>/dev/null
        COMPREPLY+=("${toks[@]}")
    fi
}

# @param $1 exclude  Characters out of $COMP_WORDBREAKS which should NOT be
#     considered word breaks. This is useful for things like scp where
#     we want to return host:path and not only path, so we would pass the
#     colon (:) as $1 in this case.
# @param $2 words  Name of variable to return words to
# @param $3 cword  Name of variable to return cword to
# @param $4 cur  Name of variable to return current word to complete to
# @see __reassemble_comp_words_by_ref()
__get_cword_at_cursor_by_ref()
{
    local cword words=()
    __reassemble_comp_words_by_ref "$1" words cword

    local i cur="" index=$COMP_POINT lead=${COMP_LINE:0:COMP_POINT}
    # Cursor not at position 0 and not led by just space(s)?
    if [[ $index -gt 0 && ($lead && ${lead//[[:space:]]/}) ]]; then
        cur=$COMP_LINE
        for ((i = 0; i <= cword; ++i)); do
            # Current word fits in $cur, and $cur doesn't match cword?
            while [[ ${#cur} -ge ${#words[i]} && \
                ${cur:0:${#words[i]}} != "${words[i]-}" ]]; do
                # Strip first character
                cur="${cur:1}"
                # Decrease cursor position, staying >= 0
                ((index > 0)) && ((index--))
            done

            # Does found word match cword?
            if ((i < cword)); then
                # No, cword lies further;
                local old_size=${#cur}
                cur="${cur#"${words[i]}"}"
                local new_size=${#cur}
                ((index -= old_size - new_size))
            fi
        done
        # Clear $cur if just space(s)
        [[ $cur && ! ${cur//[[:space:]]/} ]] && cur=
        # Zero $index if negative
        ((index < 0)) && index=0
    fi

    local "$2" "$3" "$4" && _upvars -a${#words[@]} $2 ${words+"${words[@]}"} \
        -v $3 "$cword" -v $4 "${cur:0:index}"
}

# Reassemble command line words, excluding specified characters from the
# list of word completion separators (COMP_WORDBREAKS).
# @param $1 chars  Characters out of $COMP_WORDBREAKS which should
#     NOT be considered word breaks. This is useful for things like scp where
#     we want to return host:path and not only path, so we would pass the
#     colon (:) as $1 here.
# @param $2 words  Name of variable to return words to
# @param $3 cword  Name of variable to return cword to
#
__reassemble_comp_words_by_ref()
{
    local exclude i j line ref
    # Exclude word separator characters?
    if [[ $1 ]]; then
        # Yes, exclude word separator characters;
        # Exclude only those characters, which were really included
        exclude="[${1//[^$COMP_WORDBREAKS]/}]"
    fi

    # Default to cword unchanged
    printf -v "$3" %s "$COMP_CWORD"
    # Are characters excluded which were former included?
    if [[ -v exclude ]]; then
        # Yes, list of word completion separators has shrunk;
        line=$COMP_LINE
        # Re-assemble words to complete
        for ((i = 0, j = 0; i < ${#COMP_WORDS[@]}; i++, j++)); do
            # Is current word not word 0 (the command itself) and is word not
            # empty and is word made up of just word separator characters to
            # be excluded and is current word not preceded by whitespace in
            # original line?
            while [[ $i -gt 0 && ${COMP_WORDS[i]} == +($exclude) ]]; do
                # Is word separator not preceded by whitespace in original line
                # and are we not going to append to word 0 (the command
                # itself), then append to current word.
                [[ $line != [[:blank:]]* ]] && ((j >= 2)) && ((j--))
                # Append word separator to current or new word
                ref="$2[$j]"
                printf -v "$ref" %s "${!ref-}${COMP_WORDS[i]}"
                # Indicate new cword
                ((i == COMP_CWORD)) && printf -v "$3" %s "$j"
                # Remove optional whitespace + word separator from line copy
                line=${line#*"${COMP_WORDS[i]}"}
                # Start new word if word separator in original line is
                # followed by whitespace.
                [[ $line == [[:blank:]]* ]] && ((j++))
                # Indicate next word if available, else end *both* while and
                # for loop
                ((i < ${#COMP_WORDS[@]} - 1)) && ((i++)) || break 2
            done
            # Append word to current word
            ref="$2[$j]"
            printf -v "$ref" %s "${!ref-}${COMP_WORDS[i]}"
            # Remove optional whitespace + word from line copy
            line=${line#*"${COMP_WORDS[i]}"}
            # Indicate new cword
            ((i == COMP_CWORD)) && printf -v "$3" %s "$j"
        done
        ((i == COMP_CWORD)) && printf -v "$3" %s "$j"
    else
        # No, list of word completions separators hasn't changed;
        for i in "${!COMP_WORDS[@]}"; do
            printf -v "$2[i]" %s "${COMP_WORDS[i]}"
        done
    fi
}

# Complete variables.
# @return  True (0) if variables were completed,
#          False (> 0) if not.
_variables()
{
    if [[ $cur =~ ^(\$(\{[!#]?)?)([A-Za-z0-9_]*)$ ]]; then
        # Completing $var / ${var / ${!var / ${#var
        if [[ $cur == '${'* ]]; then
            local arrs vars
            vars=($(compgen -A variable -P ${BASH_REMATCH[1]} -S '}' -- ${BASH_REMATCH[3]}))
            arrs=($(compgen -A arrayvar -P ${BASH_REMATCH[1]} -S '[' -- ${BASH_REMATCH[3]}))
            if ((${#vars[@]} == 1 && ${#arrs[@]} != 0)); then
                # Complete ${arr with ${array[ if there is only one match, and that match is an array variable
                compopt -o nospace
                COMPREPLY+=(${arrs[*]})
            else
                # Complete ${var with ${variable}
                COMPREPLY+=(${vars[*]})
            fi
        else
            # Complete $var with $variable
            COMPREPLY+=($(compgen -A variable -P '$' -- "${BASH_REMATCH[3]}"))
        fi
        return 0
    elif [[ $cur =~ ^(\$\{[#!]?)([A-Za-z0-9_]*)\[([^]]*)$ ]]; then
        # Complete ${array[i with ${array[idx]}
        local IFS=$'\n'
        COMPREPLY+=($(compgen -W '$(printf %s\\n "${!'${BASH_REMATCH[2]}'[@]}")' \
            -P "${BASH_REMATCH[1]}${BASH_REMATCH[2]}[" -S ']}' -- "${BASH_REMATCH[3]}"))
        # Complete ${arr[@ and ${arr[*
        if [[ ${BASH_REMATCH[3]} == [@*] ]]; then
            COMPREPLY+=("${BASH_REMATCH[1]}${BASH_REMATCH[2]}[${BASH_REMATCH[3]}]}")
        fi
        __ltrim_colon_completions "$cur" # array indexes may have colons
        return 0
    elif [[ $cur =~ ^\$\{[#!]?[A-Za-z0-9_]*\[.*\]$ ]]; then
        # Complete ${array[idx] with ${array[idx]}
        COMPREPLY+=("$cur}")
        __ltrim_colon_completions "$cur"
        return 0
    fi
    return 1
}

# If the word-to-complete contains a colon (:), left-trim COMPREPLY items with
# word-to-complete.
# With a colon in COMP_WORDBREAKS, words containing
# colons are always completed as entire words if the word to complete contains
# a colon.  This function fixes this, by removing the colon-containing-prefix
# from COMPREPLY items.
# The preferred solution is to remove the colon (:) from COMP_WORDBREAKS in
# your .bashrc:
#
#    # Remove colon (:) from list of word completion separators
#    COMP_WORDBREAKS=${COMP_WORDBREAKS//:}
#
# See also: Bash FAQ - E13) Why does filename completion misbehave if a colon
# appears in the filename? - https://tiswww.case.edu/php/chet/bash/FAQ
# @param $1 current word to complete (cur)
# @modifies global array $COMPREPLY
#
__ltrim_colon_completions()
{
    if [[ $1 == *:* && $COMP_WORDBREAKS == *:* ]]; then
        # Remove colon-word prefix from COMPREPLY items
        local colon_word=${1%"${1##*:}"}
        local i=${#COMPREPLY[*]}
        while ((i-- > 0)); do
            COMPREPLY[i]=${COMPREPLY[i]#"$colon_word"}
        done
    fi
}

_get_comp_words_by_ref()
{
    local exclude flag i OPTIND=1
    local cur cword words=()
    local upargs=() upvars=() vcur vcword vprev vwords

    while getopts "c:i:n:p:w:" flag "$@"; do
        case $flag in
            c) vcur=$OPTARG ;;
            i) vcword=$OPTARG ;;
            n) exclude=$OPTARG ;;
            p) vprev=$OPTARG ;;
            w) vwords=$OPTARG ;;
            *)
                echo "bash_completion: $FUNCNAME: usage error" >&2
                return 1
                ;;
        esac
    done
    while [[ $# -ge $OPTIND ]]; do
        case ${!OPTIND} in
            cur) vcur=cur ;;
            prev) vprev=prev ;;
            cword) vcword=cword ;;
            words) vwords=words ;;
            *)
                echo "bash_completion: $FUNCNAME: \`${!OPTIND}':" \
                    "unknown argument" >&2
                return 1
                ;;
        esac
        ((OPTIND += 1))
    done

    __get_cword_at_cursor_by_ref "${exclude-}" words cword cur

    [[ -v vcur ]] && {
        upvars+=("$vcur")
        upargs+=(-v $vcur "$cur")
    }
    [[ -v vcword ]] && {
        upvars+=("$vcword")
        upargs+=(-v $vcword "$cword")
    }
    [[ -v vprev && $cword -ge 1 ]] && {
        upvars+=("$vprev")
        upargs+=(-v $vprev "${words[cword - 1]}")
    }
    [[ -v vwords ]] && {
        upvars+=("$vwords")
        upargs+=(-a${#words[@]} $vwords ${words+"${words[@]}"})
    }

    ((${#upvars[@]})) && local "${upvars[@]}" && _upvars "${upargs[@]}"
}

# Assign variables one scope above the caller
# Usage: local varname [varname ...] &&
#        _upvars [-v varname value] | [-aN varname [value ...]] ...
# Available OPTIONS:
#     -aN  Assign next N values to varname as array
#     -v   Assign single value to varname
# Return: 1 if error occurs
# See: https://fvue.nl/wiki/Bash:_Passing_variables_by_reference
_upvars()
{
    if ! (($#)); then
        echo "bash_completion: $FUNCNAME: usage: $FUNCNAME" \
            "[-v varname value] | [-aN varname [value ...]] ..." >&2
        return 2
    fi
    while (($#)); do
        case $1 in
            -a*)
                # Error checking
                [[ ${1#-a} ]] || {
                    echo "bash_completion: $FUNCNAME:" \
                        "\`$1': missing number specifier" >&2
                    return 1
                }
                printf %d "${1#-a}" &>/dev/null || {
                    echo bash_completion: \
                        "$FUNCNAME: \`$1': invalid number specifier" >&2
                    return 1
                }
                # Assign array of -aN elements
                [[ "$2" ]] && unset -v "$2" && eval $2=\(\"\$"{@:3:${1#-a}}"\"\) &&
                    shift $((${1#-a} + 2)) || {
                    echo bash_completion: \
                        "$FUNCNAME: \`$1${2+ }$2': missing argument(s)" \
                        >&2
                    return 1
                }
                ;;
            -v)
                # Assign single value
                [[ "$2" ]] && unset -v "$2" && eval $2=\"\$3\" &&
                    shift 3 || {
                    echo "bash_completion: $FUNCNAME: $1:" \
                        "missing argument(s)" >&2
                    return 1
                }
                ;;
            *)
                echo "bash_completion: $FUNCNAME: $1: invalid option" >&2
                return 1
                ;;
        esac
    done
}

_nmcli_array_delete_at() {

    eval "local ARRAY=(\"\${$1[@]}\")"
    local i
    local tmp=()
    local lower=$2
    local upper=${3:-$lower}

    # for some reason the following fails. So this clumsy workaround...
    #   A=(a "")
    #   echo " >> ${#A[@]}"
    #    >> 2
    #   A=("${A[@]:1}")
    #   echo " >> ${#A[@]}"
    #    >> 0
    # ... seriously???

    for i in "${!ARRAY[@]}"; do
        if [[ "$i" -lt "$2" || "$i" -gt "${3-$2}" ]]; then
            tmp=("${tmp[@]}" "${ARRAY[$i]}")
        fi
    done
    eval "$1=(\"\${tmp[@]}\")"
}

_nmcli() {
    local cur words cword i output
    _init_completion || return

    # we don't care about any arguments after the current cursor position
    # because we only parse from left to right. So, if there are some arguments
    # right of the cursor, just ignore them. Also don't care about ${words[0]}.
    _nmcli_array_delete_at words $((cword+1)) ${#words[@]}
    _nmcli_array_delete_at words 0

    # _init_completion returns the words with all the quotes and escaping
    # characters. We don't care about them, drop them at first.
    for i in ${!words[@]}; do
        words[i]="$(printf '%s' "${words[i]}" | xargs printf '%s\n' 2>/dev/null || true)"
    done

    # In case the cursor is not at the end of the line,
    # $cur consists of spaces that we want do remove.
    # For example: `nmcli connection modify id  <TAB>  lo`
    if [[ "$cur" =~ ^[[:space:]]+ ]]; then
        cur=''
    fi

    output="$(nmcli --complete-args "${words[@]}" 2>/dev/null)"

    # Bail out early if we're completing a file name
    if [ $? = 65 ]; then
        compopt -o default
        COMPREPLY=()
        return 0
    fi

    local IFS=$'\n'
    COMPREPLY=( $( compgen -W '$output' -- $cur ) )

    # Now escape special characters (spaces, single and double quotes),
    # so that the argument is really regarded a single argument by bash.
    # See http://stackoverflow.com/questions/1146098/properly-handling-spaces-and-quotes-in-bash-completion
    local escaped_single_quote="'\''"
    local i=0
    local entry
    for entry in ${COMPREPLY[*]}
    do
        if [[ "${cur:0:1}" == "'" ]]; then
            # started with single quote, escaping only other single quotes
            # [']bla'bla"bla\bla bla --> [']bla'\''bla"bla\bla bla
            COMPREPLY[$i]="${entry//\'/${escaped_single_quote}}"
        elif [[ "${cur:0:1}" == '"' ]]; then
            # started with double quote, escaping all double quotes and all backslashes
            # ["]bla'bla"bla\bla bla --> ["]bla'bla\"bla\\bla bla
            entry="${entry//\\/\\\\}"
            entry="${entry//\"/\\\"}"
            entry="${entry//!/\"\\!\"}"
            COMPREPLY[$i]="$entry"
        else
            # no quotes in front, escaping _everything_
            # [ ]bla'bla"bla\bla bla --> [ ]bla\'bla\"bla\\bla\ bla
            entry="${entry//\\/\\\\}"
            entry="${entry//\'/\'}"
            entry="${entry//\"/\\\"}"
            entry="${entry// /\\ }"
            entry="${entry//\(/\\(}"
            entry="${entry//)/\\)}"
            entry="${entry//!/\\!}"
            entry="${entry//&/\\&}"
            COMPREPLY[$i]="$entry"
        fi
        (( i++ ))
    done

    # Work-around bash_completion issue where bash interprets a colon
    # as a separator.
    # Colon is escaped here. Change "\\:" back to ":".
    # See also:
    # http://stackoverflow.com/questions/28479216/how-to-give-correct-suggestions-to-tab-complete-when-my-words-contains-colons
    # http://stackoverflow.com/questions/2805412/bash-completion-for-maven-escapes-colon/12495727
    i=0
    for entry in ${COMPREPLY[*]}
    do
        entry="${entry//\\\\:/:}"
        COMPREPLY[$i]=${entry}
        (( i++ ))
    done

} &&
complete -F _nmcli nmcli

# ex: ts=4 sw=4 et filetype=sh
