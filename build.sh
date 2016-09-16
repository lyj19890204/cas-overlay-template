#!/bin/bash


function copy() {
	echo -e "Creating configuration directory under /etc/cas"
	mkdir -p /etc/cas/config

	echo -e "Copying configuration files from etc/cas to /etc/cas"
	cp -rfv etc/cas/* /etc/cas
}

function help() {
	echo "Usage: build.sh [copy|clean|package|run]"	
}

function clean() {
	./mvnw clean "$@"
}

function package() {
	./mvnw clean package -T 5 "$@"
	copy
}


function run() {
	package && java -Xdebug -Xrunjdwp:transport=dt_socket,address=5000,server=y,suspend=n -jar target/cas.war 
}

if [ $# -eq 0 ]; then
    echo -e "No commands provided. Defaulting to [run]\n"
    run
    exit 0
fi


case "$1" in
"copy")
    copy 
    ;;
"clean")
	shift
    clean "$@"
    ;;   
"package")
	shift
    package "$@"
    ;;
"run")
    run "$@"
    ;;
*)
    help
    ;;
esac

