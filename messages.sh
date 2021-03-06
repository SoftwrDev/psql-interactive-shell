#!/bin/bash

source ./commands.sh

helpMessage() {
	for key in ${!commands[@]}; do
		echo "$key" | sed -r "s/(.*)_(.*)/\1 \2: /"
		printf "\t%s\n" "${commands[$key]}"
	done
	printf "\n"
}

exitMessage() {
	printf "Bye bye!! See you again later!\n\n"
}

invalidCommandMessage() {
	printf "Invalid command... Type \"help\" or \"h\" if you want some rescue\n\n"
}
