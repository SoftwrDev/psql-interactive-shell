#!/bin/bash

source ./messages.sh
source ./shell_functions.sh
source ./commands.sh

checkEmptyCredentials
checkEmptyDatabaseProvided
prepareEnv
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
