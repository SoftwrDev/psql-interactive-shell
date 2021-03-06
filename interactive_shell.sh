#!/bin/bash

source ./messages.sh
source ./shell_functions.sh
source ./commands.sh

checkEmptyCredentials
checkEmptyDatabaseProvided
checkCodeEditor

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

	if [[ -v "commandFactory[$cmd]" ]]; then
		eval "${commandFactory[$cmd]}"
		continue
	fi

	invalidCommandMessage
done
