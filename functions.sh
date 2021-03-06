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

listTables() {
	psql -c "\dt"
}

listDatabases() {
	psql -c "\l"
}

dropTable() {
	echo -n "What is the name of the table you want to delete? "
	read tableName

	printf "Are you sure you wanna delete %s table? [y/N] " "$tableName"
	read shouldDelete

	if [[ $shouldDelete == "y" || $shouldDelete == "Y" ]]; then
		psql -c "DROP TABLE IF EXISTS $tableName;"

		if [[ -z $? ]]; then
			echo "Table $tableName deleted with success!"
		else
			echo "Error while deleting $tableName..."
		fi
	fi

	printf "\n"
}
