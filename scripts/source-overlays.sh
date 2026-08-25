# shellcheck shell=sh
# Runtime merge of personal overlay env.
# Sourced by login shells. Do not enable set -e / set -u here.
# Do not read these files in Nix (secrets must not enter the store).
#
# Later assignment wins:
#   1. $HOME/local.env
#   2. $HOME/.config/local.env
#   3. $HOME/.config/me/local.env  (non-empty keys only; ME overlay wins)

_me_dot_env() {
    if [ -r "$1" ]; then
        set -a
        # shellcheck disable=SC1090
        . "$1"
        set +a
    fi
}

_me_export_nonempty() {
    _me_file=$1
    if [ ! -r "$_me_file" ]; then
        return 0
    fi
    _me_cr=$(printf '\r')
    while IFS= read -r _me_line || [ -n "${_me_line-}" ]; do
        _me_line=${_me_line%"$_me_cr"}
        while :; do
            case $_me_line in
                [[:space:]]*) _me_line=${_me_line#?} ;;
                *) break ;;
            esac
        done
        case $_me_line in
            '' | '#'*) continue ;;
        esac
        case $_me_line in
            export[[:space:]]*)
                _me_pfx=export
                _me_line=${_me_line#$_me_pfx}
                while :; do
                    case $_me_line in
                        [[:space:]]*) _me_line=${_me_line#?} ;;
                        *) break ;;
                    esac
                done
                ;;
        esac
        case $_me_line in
            *=*)
                _me_key=${_me_line%%=*}
                _me_raw=${_me_line#*=}
                ;;
            *) continue ;;
        esac
        case $_me_key in
            '' | *[!A-Za-z0-9_]* | [0-9]*) continue ;;
        esac
        case $_me_raw in
            \'*)
                _me_raw=${_me_raw#\'}
                _me_val=${_me_raw%%\'*}
                ;;
            \"*)
                _me_raw=${_me_raw#\"}
                _me_val=${_me_raw%%\"*}
                ;;
            *)
                _me_val=$(printf '%s\n' "$_me_raw" | sed 's/[[:space:]#].*//')
                ;;
        esac
        if [ -n "$_me_val" ]; then
            export "$_me_key=$_me_val"
        fi
    done <"$_me_file"
    unset _me_file _me_line _me_key _me_raw _me_val _me_cr _me_pfx
}

if [ -n "${HOME-}" ]; then
    _me_dot_env "$HOME/local.env"
    _me_dot_env "$HOME/.config/local.env"
    _me_export_nonempty "$HOME/.config/me/local.env"
fi
unset -f _me_dot_env _me_export_nonempty
