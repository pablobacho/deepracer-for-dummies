#!/usr/bin/env bash

if [ -x "$(command -v gnome-terminal)" ]; then
    terminal_cmd="gnome-terminal -x"
    echo 'using gnome-terminal'
elif [ -x "$(command -v konsole)" ]; then
    terminal_cmd="konsole -e"
    echo 'using konsole'
else
    echo 'script needs gnome-terminal or konsole. exiting...'
    exit
fi

export ROBOMAKER_COMMAND="./run.sh build distributed_training.launch"

docker-compose -f ../../docker/docker-compose.yml up -d
echo 'waiting for containers to start up...'

#sleep for 20 seconds to allow the containers to start
sleep 15

echo 'attempting to pull up sagemaker logs...'
$terminal_cmd sh -c "!!; docker logs -f $(docker ps | awk ' /sagemaker/ { print $1 }')" &

echo 'attempting to open vnc viewer...'
$terminal_cmd sh -c "!!; vncviewer localhost:8080"