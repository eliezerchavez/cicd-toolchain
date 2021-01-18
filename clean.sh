#!/usr/bin/env bash

#
#functions
#

#
# Name: warning
# Date: 2021-01-14
# displays warning message in standard output.
#
warning() {
    tries=1
    maxTries=3

    echo ""
    echo " Stop & Delete CI/CD Toolchain"
    echo " ------------------------------------------------------------"
    echo ""
    echo " Press Ctrl-c to abort."
    echo ""
    echo -e " \e[5mWARNING:"
    echo -e " \e[0mAll the  tools  and  its  stored info  will be destroyed!"
    echo " Access to all jobs, projects, configuration and artifacts"
    echo " repository  will be lost unless a backup of the these has"
    echo " been created."
    echo ""
    echo " Are you sure that you  want to  stop & delete  the  CI/CD"
    echo " Toolchain?"
    echo ""
    echo -ne " Type DESTROY to confirm: "
    read -r prompt
    while [ ${prompt} != 'DESTROY' -a ${tries} -lt ${maxTries} ]; do
        tries=$((tries+1))
        echo -e '\e[2A'
        echo -ne " Type DESTROY to confirm: \e[K"
        read -r prompt
    done

    if [ ${tries} -eq ${maxTries} ]; then
        exit 1
    fi
    tput init
}

#
# Name: usage
# Date: 2021-01-06
# displays usage message in standard output.
#
usage() {
    echo "usage: clean.sh [options]"
    echo "toolchain.sh options:"
    echo "  --help  this usage message"
    exit 1
}

#
# Name: doClean
# Date: 2021-01-06
# clean created files/dirs
#
doClean() {
    # jenkins
    sudo rm -fr ./storage/jenkins
    
    # nexus
    sudo rm -fr ./storage/nexus
    
    # postgresql
    sudo rm -fr ./storage/postgres/data

    # sonarqube
    sudo rm -fr ./storage/sonarqube
}

#
#main
#
#reading program arguments
#
until [ -z "$1" ] #until all parameters used up...
do
    case "$1" in
        "--help")
            usage
            ;;
    esac
    shift
done

warning
docker rm -f $(docker ps -qa) 2>/dev/null
doClean

echo ""
echo " DONE."
