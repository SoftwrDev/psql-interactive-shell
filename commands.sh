#!/bin/bash

declare -A commands
declare -A commandFactory

listTables() {
        psql -c "\dt"
}

commands["list_tables"]="show all available tables"
commandFactory["list tables"]="listTables && echo"

listDatabases() {
        psql -c "\l"
}

commands["list_databases"]="show all databases available"
commandFactory["list databases"]="listDatabases && echo"

dropTable() {
        echo -n "What is the name of the table you want to delete? "
        read tableName

        printf "Are you sure you wanna delete %s table? [y/N] " "$tableName"
        read shouldDelete

        if [[ $shouldDelete == "y" || $shouldDelete == "Y" ]]; then
                psql -c "DROP TABLE $tableName;"

                if [[ -z $? ]]; then
                        printf "Table %s deleted with success!\n\n" "$tableName"
                        return
                fi

                printf "Error while deleting %s...\n\n" "$tableName"
        fi

}

commands["drop_table"]="deletes a table if it exists"
commandFactory["drop table"]="dropTable && echo"
