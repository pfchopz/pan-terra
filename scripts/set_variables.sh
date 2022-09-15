#!/bin/bash

# Script to help set up initial terraform environment variables for Pan Terra
if [[ $# -lt 2 ]] ; then
    echo ''
    echo "USAGE:    ./set_variables.sh 'user' 'pass'"
    echo ''
    echo "USAGE:    ./set_variables.sh 'user' 'pass' 'version' 'license' 'region' 'instance' 'zone_id' 'record'"
    echo ''
    echo "EXAMPLE:  ./set_variables.sh 'admin' 'Password1!' '10.2.2' 'full' 'oregon' 'm5.xlarge' 'ZmFrZSByb3V0ZTUzI' 'pan'"
    echo ''
    echo 'user          - Palo Alto user name, default is "admin"'
    echo 'pass          - Palo Alto password, default is "Password123!"'
    echo 'version       - PAN-OS version, default is "10.2.2"'
    echo 'license       - PAN-OS license, default is "full", alternates: "partial"'
    echo 'region        - AWS region, default is "oregon", alternates: "virginia", "ohio", "california"'
    echo 'instance      - EC2 instance type, default is "m5.xlarge"' 
    echo 'zone_id       - OPTIONAL Route53 zone ID, default is null'
    echo 'record        - OPTIONAL Route53 A record, default is "pan", e.g. record.example.com'
    echo ''
    return
fi

if [[ $# -gt 8 ]] ; then
    echo ''
    echo 'Too many arguments'
    return
fi

if [[ ! -z "$1" ]] ; then
    export TF_VAR_panos_username=$1
    echo 'Set Palo Alto username to:      '$1
fi

if [[ ! -z "$2" ]] ; then
    export TF_VAR_panos_password=$2
    echo 'Set Palo Alto username to:      '$2
fi

if [[ ! -z "$3" ]] ; then
    export TF_VAR_os_version=$3
    echo 'Set PAN-OS version to:          '$3
fi

if [[ ! -z "$4" ]] ; then
    export TF_VAR_license=$4
    echo 'Set Palo Alto license to:       '$4
fi

if [[ ! -z "$5" ]] ; then
    export TF_VAR_region_id=$5
    echo 'Set AWS region to:              '$5
fi

if [[ ! -z "$6" ]] ; then
    export TF_VAR_instance_type=$6
    echo 'Set AWS instance type to:       '$6
fi

if [[ ! -z "$7" ]] ; then
    export TF_VAR_route53_zone_id=$7
    echo 'Set Route 53 Zone ID to:        '$7
fi

if [[ ! -z "$8" ]] ; then
    export TF_VAR_route53_a_record=$8
    echo 'Set Route 53 DNS A-Record to:   '$8
fi