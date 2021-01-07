#!/usr/bin/env bash

export GROUP_ID=$(id -g)
export USER__ID=$(id -u)

#
#functions
#

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
        docker-compose down --remove-orphans
        doClean
        ;;
    "down")
        docker-compose down
        ;;
    "init")
        doClean
        doInit
        docker-compose up --build -d
        docker exec -itu root jenkins bash -c "getent group docker || groupadd docker && usermod -aG docker jenkins && chgrp docker /var/run/docker.sock"
        docker-compose restart jenkins
        ;;
    "up")
        docker-compose up -d
        docker exec -itu root jenkins bash -c "getent group docker || groupadd docker && usermod -aG docker jenkins && chgrp docker /var/run/docker.sock"
        docker-compose restart jenkins
        ;;
    "start")
        docker-compose start
        ;;
    "stop")
        docker-compose stop
        ;;
esac
