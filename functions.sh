#!/bin/bash

checkEmptyCredentials() {
	if [[ ${#LOGIN} -eq 0 || ${#PASSWORD} -eq 0 ]]; then
    		echo "Invalid credentials"
    		exit 1
	fi
}

checkEmptyDatabaseProvided() {
	if [[ ${DBNAME} == "" ]]; then
		echo "Database name not provided"
		exit 1
	fi
}

testPsqlConnectivity() {
	psql -c "\l" > /dev/null 2>&1

	if [[ $? -ne 0 ]]; then
		printf "Unable to connect to database. Check if the database is really available\n\n"
		exit 1
	fi
}
