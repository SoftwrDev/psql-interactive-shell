#!/bin/bash

source ./messages.sh
source ./functions.sh

checkEmptyCredentials
checkEmptyDatabaseProvided

export PGHOST=127.0.0.1
export PGPORT=5432
export PGUSER=$LOGIN
export PGDATABASE=$DBNAME
export PGPASSWORD=$PASSWORD


testPsqlConnectivity

clear

while true
do
	echo -n "Hello there, what do you wanna do? "

	read command

	if [[ $command == "help" || $command == "h" ]]; then
		help
		continue
	fi

	if [[ $command == "exit" || $command == "quit" ]]; then
		exit_message
		break
	fi

	if [[ $command == "clear" ]]; then
		clear
		continue
	fi

	invalid_command_message
	continue

	psql
done
