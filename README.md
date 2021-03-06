# PSQL Interactive Shell

This is an attempt to create an easy shellscript to be used as an api to interact with postgresql through bash terminal.

For simple stuff you can create and drop tables. Do some basic queries (SELECT, INSERT, DELETE and UPDATE) query with one table. 

If you want to write some more advanced query you should try `raw query` command.

If for some reason you get stuck, you can always type `help` or `h` to get help with the commands.

## Requirements
You should have a shell compatible with bash commands and syntax and also you may need to set some variables to get the script to work:

### Environment variables

`LOGIN` or `PGUSER` = user login used by postgres

`PGDATABASE` or `DB_NAME` = name of the database

`PGPASSWORD` or `PASSWORD` = password used to login

`DB_HOST` or `PG_HOST` = host address to connect to the postgres database

`DB_PORT` or `PG_PORT` = port in where the database is running

`CODE_EDITOR` = code editor you want to use when writing raw queries (when not set it sets itself as nano by default)
