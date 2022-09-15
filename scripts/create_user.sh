#!/bin/bash

# Script to compile go binary and run program to create Palo Alto user
if [[ $# -lt 1 ]] ; then
    echo ''
    echo "USAGE:    ./create_user.sh <ssh_private_key_file>"
    echo ''
    exit 1
else
    go mod init github.com/user/pan-terra
    go get golang.org/x/crypto/ssh
    go build -o bin src/panos_init.go
    sleep 60
    ./bin/panos_init $1
fi