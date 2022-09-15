#!/bin/bash

# Curl request with encoded credentials with Basic Auth to query Palo Alto API to export configuration
if [[ $# -lt 3 ]] ; then
    echo ''
    echo "USAGE:    ./backup_config.sh 'username' 'password' 'fqdn'"
    echo ''
    exit 1
else
    current_time=$(date "+%Y.%m.%d-%H.%M.%S")
    encodedCreds=$(echo -n "$1:$2" | base64)
    curl -k -H "Authorization: Basic $encodedCreds" -X GET "https://$3/api/?type=export&category=configuration" > ./backups/backup_$current_time.xml
fi