#!/bin/bash

source ./src/messages.sh
source ./src/shell_functions.sh
source ./src/commands.sh

checkEmptyCredentials
checkEmptyDatabaseProvided
prepareEnv
testPsqlConnectivity

clear

while true; do

	echo -n "Hello there, what do you wanna do? "
	read cmd

	[ -v "commandFactory[$cmd]" ] && eval "${commandFactory[$cmd]}"; continue

	invalidCommandMessage
done
