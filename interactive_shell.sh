#!/bin/bash

if [[ ${#LOGIN} -eq 0 || ${#PASSWORD} -eq 0 ]]; then
    echo "Invalid credentials"
    exit 1
fi

if [[ ${DBNAME} == "" ]]; then
    echo "Database name not provided"
    exit 1
fi

export PGHOST=127.0.0.1
export PGPORT=5432
export PGUSER=$LOGIN
export PGDATABASE=$DBNAME
export PGPASSWORD=$PASSWORD

clear

source ./messages.sh

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
