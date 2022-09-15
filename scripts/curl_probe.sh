#!/bin/bash

# Curl loop to check for HTTP response of host
if [[ $# -lt 1 ]] ; then
    echo ''
    echo "USAGE:    ./curl_probe.sh 'hostname'"
    echo ''
    exit 1
else
    until $(curl --insecure --output /dev/null --silent --head --fail https://$1); do
        sleep 5
    done
fi