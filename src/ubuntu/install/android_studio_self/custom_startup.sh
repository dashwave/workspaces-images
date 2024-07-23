#!/usr/bin/env bash
set -ex
START_COMMAND="/home/kasm-user/android-studio/bin/studio.sh /config/workspace/code"
PGREP="android-studio"
export MAXIMIZE="true"
export export MAXIMIZE_NAME="code"
DEFAULT_ARGS=""
MAXIMIZE_SCRIPT=$STARTUPDIR/maximize_window.sh
VSCODE_SCRIPT=$STARTUPDIR/vscode_startup.sh

if [[ $MAXIMIZE == 'true' ]] ; then
    DEFAULT_ARGS+=" --start-maximized"
fi
ARGS=${APP_ARGS:-$DEFAULT_ARGS}

options=$(getopt -o gau: -l go,assign,url: -n "$0" -- "$@") || exit
eval set -- "$options"

while [[ $1 != -- ]]; do
    case $1 in
        -g|--go) GO='true'; shift 1;;
        -a|--assign) ASSIGN='true'; shift 1;;
        *) echo "bad option: $1" >&2; exit 1;;
    esac
done
shift

# Process non-option arguments.
for arg; do
    echo "arg! $arg"
done

echo workign

FORCE=$2

kasm_exec() {
    /usr/bin/filter_ready
    /usr/bin/desktop_ready
    $START_COMMAND $ARGS $OPT_URL
}

kasm_startup() {
    if [ -n "$KASM_URL" ] ; then
        URL=$KASM_URL
    elif [ -z "$URL" ] ; then
        URL=$LAUNCH_URL
    fi

    if [ -z "$DISABLE_CUSTOM_STARTUP" ] ||  [ -n "$FORCE" ] ; then
        echo "Entering process startup loop"
        set +x
        while true
        do
            if ! pgrep -x $PGREP > /dev/null
            then
                /usr/bin/filter_ready
                /usr/bin/desktop_ready
                set +e
                bash ${VSCODE_SCRIPT} &
                sudo -E $START_COMMAND
                set -e
            fi
            sleep 1
        done
        set -x
    
    fi

} 

if [ -n "$GO" ] || [ -n "$ASSIGN" ] ; then
    kasm_exec
else
    kasm_startup
fi
