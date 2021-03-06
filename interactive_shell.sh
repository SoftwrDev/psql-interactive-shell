#!/bin/bash

source ./messages.sh
source ./shell_functions.sh
source ./commands.sh

checkEmptyCredentials
checkEmptyDatabaseProvided

export PGHOST=127.0.0.1
export PGPORT=5432
export PGUSER=$LOGIN
export PGDATABASE=$DBNAME
export PGPASSWORD=$PASSWORD

testPsqlConnectivity

clear

while true; do

	echo -n "Hello there, what do you wanna do? "
	read cmd

	if [[ $cmd == "help" || $cmd == "h" ]]; then
		helpMessage
		continue
	fi

	if [[ $cmd == "clear" ]]; then
                clear
                continue
        fi

	if [[ $cmd == "exit" || $cmd == "quit" ]]; then
		exitMessage
		break
	fi

	[ -v "commandFactory[$cmd]" ] && eval "${commandFactory[$cmd]}" || invalidCommandMessage
done
