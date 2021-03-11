#!/bin/sh

checkEmptyCredentials() {
        if [ ${#LOGIN} -eq 0 && ${#PGUSER} -eq 0 || ${#PASSWORD} -eq 0 && ${#PGPASSWORD} -eq 0 ]; then
                echo "Invalid credentials"
                exit 1
        fi
}

checkEmptyDatabaseProvided() {
        if [ ${#DBNAME} -eq 0 && ${#PGDATABASE} -eq 0 ]; then
                echo "Database name not provided"
                exit 1
        fi
}

prepareEnv() {
        [ ${#PGUSER} -eq 0 ] && export PGUSER=$LOGIN

	[ ${#PGDATABASE} -eq 0 ] && export PGDATABASE=$DBNAME

     	[ ${#PGPASSWORD} -eq 0 ] && export PGPASSWORD=$PASSWORD

       	[ ${#DB_HOST} -eq 0 && ${#PGHOST} -eq 0 ] && export PGHOST=127.0.0.1 || export PGHOST=$DB_HOST

       	[ ${#DB_PORT} -eq 0 && ${#PGPORT} -eq 0 ] && export PGPORT=5432 || export PGPORT=$DB_PORT

      	[ ${#CODE_EDITOR} -eq 0 ] && export CODE_EDITOR="vim"
}


testPsqlConnectivity() {
        psql -c "\l" > /dev/null 2>&1

        if [ $? -ne 0 ]; then
                printf "Unable to connect to database. Check if the database is really available\n\n"
                exit 1
        fi
}
