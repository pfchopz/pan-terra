#!/bin/bash

# Curl request with encoded credentials with Basic Auth to query Palo Alto API to export configuration
if [[ $# -lt 3 ]] ; then
    echo ''
    echo "USAGE:    ./restore_config.sh 'username' 'password' 'fqdn'"
    echo ''
    exit 1
else
    backup_file=$(ls -Art backups | tail -n 1)
    encodedCreds=$(echo -n "$1:$2" | base64)
    curl -k -H "Authorization: Basic $encodedCreds" --form file=@"./backups/$backup_file" -X POST "https://$3/api/?type=import&category=configuration"
    curl -k -H "Authorization: Basic $encodedCreds" -X POST "https://$3/api/?type=op&cmd=<load><config><from>$backup_file</from></config></load>"
fi