#!/usr/bin/env bash

export GROUP_ID=$(id -g)
export USER__ID=$(id -u)

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
    echo -e " \e[0mAll the tools and its stored info will be destroyed!"
    echo " Access to all jobs, projects, configuration and artifacts"
    echo " repository will be lost unless a backup of the these has"
    echo " been created."
    echo ""
    echo " Are you sure that you want to stop & delete the CI/CD"
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
}

#
# Name: usage
# Date: 2021-01-06
# displays usage message in standard output.
#
usage() {
    echo "usage: toolchain.sh { clean | down | init | up | start | stop } [options]"
    echo "toolchain.sh options:"
    echo "  --help              this usage message"
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
# Name: doInit
# Date: 2021-01-06
# creates needed files/dirs and set kernel params.
#
doInit() {
    # jenkins
    mkdir -p ./storage/jenkins/home

    # nexus
    mkdir -p ./storage/nexus/data
    chmod 777 ./storage/nexus/data

    # postgresql
    mkdir -p ./storage/postgres/data

    # sonarqube
    mkdir -p ./storage/sonarqube/data
    mkdir -p ./storage/sonarqube/logs
    mkdir -p ./storage/sonarqube/extensions

    sudo sysctl -w vm.max_map_count=262144
    sudo sysctl -w fs.file-max=65536
    sudo bash -c "ulimit -n 65536"
    sudo bash -c "ulimit -u 4096"
}

#
#main
#
#reading program arguments
#
until [ -z "$1" ] #until all parameters used up...
do
    case "$1" in
        "clean"|"down"|"init"|"up"|"start"|"stop")
            command="$1"
            ;;
        *|"--help")
            usage
            ;;
    esac
    shift
done

#
#command validation
#
if [ ! -n "$command" ]; then 
    usage
fi

case "$command" in
    "clean")
        warning
        docker-compose down --remove-orphans
        doClean
        ;;
    "down")
        docker-compose down
        ;;
    "init")
        doInit
        docker-compose up --build -d
        docker exec -u root jenkins bash -c "getent group docker || groupadd -rg $(getent group docker | cut -d':' -f3) docker && usermod -aG docker jenkins"
        docker-compose restart jenkins
        ;;
    "up")
        docker-compose up -d
        docker exec -u root jenkins bash -c "getent group docker || groupadd -rg $(getent group docker | cut -d':' -f3) docker && usermod -aG docker jenkins"
        docker-compose restart jenkins
        ;;
    "start")
        docker-compose start
        ;;
    "stop")
        docker-compose stop
        ;;
esac
