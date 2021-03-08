#!/bin/bash

checkEmptyCredentials() {
        if [[ ${#LOGIN} -eq 0 && ${#PGUSER} -eq 0 || ${#PASSWORD} -eq 0 && ${#PGPASSWORD} -eq 0 ]]; then
                echo "Invalid credentials"
                exit 1
        fi
}

checkEmptyDatabaseProvided() {
        if [[ ${#DBNAME} -eq 0 && ${#PGDATABASE} -eq 0 ]]; then
                echo "Database name not provided"
                exit 1
        fi
}

prepareEnv() {
        if [[ ${#PGUSER} -eq 0 ]]; then
                export PGUSER=$LOGIN
        fi

        if [[ ${#PGDATABASE} -eq 0 ]]; then
                export PGDATABASE=$DBNAME
        fi

        if [[ ${#PGPASSWORD} -eq 0 ]]; then
                export PGPASSWORD=$PASSWORD
        fi

        if [[ ${#DB_HOST} -eq 0 && ${#PGHOST} -eq 0 ]]; then
                export PGHOST=127.0.0.1
        else
                export PGHOST=$DB_HOST
        fi

        if [[ ${#DB_PORT} -eq 0 && ${#PGPORT} -eq 0 ]]; then
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
