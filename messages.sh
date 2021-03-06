#!/bin/bash

helpMessage() {
	echo "use \"list tables\" to see all tables"
	printf "use \"list databases\" to see all the databases\n\n"
}

exitMessage() {
	printf "Bye bye!! See you again later!\n\n"
}

invalidCommandMessage() {
	printf "Invalid command... Type \"help\" or \"h\" if you want some rescue\n\n"
}
