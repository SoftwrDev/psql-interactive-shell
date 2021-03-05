#!/bin/bash

if [[ ${#LOGIN} -eq 0 || ${#PASSWORD} -eq 0 ]]; then
    echo "Invalid credentials"
    exit 1
fi

if [[ ${DBNAME} == "" ]]; then
    echo "Database name not provided"
    exit 1
fi

export PGHOST=127.0.0.1
export PGPORT=5432
export PGUSER=$LOGIN
export PGDATABASE=$DBNAME
export PGPASSWORD=$PASSWORD

psql