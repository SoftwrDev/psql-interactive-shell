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

prepareEnv() {
	export PGUSER=$LOGIN
	export PGDATABASE=$DBNAME
	export PGPASSWORD=$PASSWORD

	if [[ ${#DB_HOST} -eq 0 ]]; then
		export PGHOST=127.0.0.1
	else
		export PGHOST=$DB_HOST
	fi

	if [[ ${#DB_PORT} -eq 0 ]]; then
		export PGPORT=5432
	else
		export PGPORT=$DB_PORT
	fi

        if [[ ${#CODE_EDITOR} -eq 0 ]]; then
                export CODE_EDITOR="nano"
        fi

}


testPsqlConnectivity() {
	psql -c "\l" > /dev/null 2>&1

	if [[ $? -ne 0 ]]; then
		printf "Unable to connect to database. Check if the database is really available\n\n"
		exit 1
	fi
}

