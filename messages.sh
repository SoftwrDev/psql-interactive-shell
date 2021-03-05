#!/bin/bash

help() {
	echo "use \"list tables\" to see all tables"
	printf "use \"list databases\" to see all the databases\n\n"
}

exit_message() {
	printf "Bye bye!! See you again later!\n\n"
}

invalid_command_message() {
	printf "Invalid command... Type \"help\" or \"h\" if you want some rescue\n\n"
}
