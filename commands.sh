#!/bin/bash

declare -A commands
declare -A commandFactory

commands["help(h)"]="show availables commands"
commandFactory["help"]="helpMessage"
commandFactory["h"]="helpMessage"

commands["clear"]="clears terminal output"
commandFactory["clear"]="clear"

commands["exit(quit)"]="exits shell"
commandFactory["exit"]="exitMessage && break"
commandFactory["quit"]="exitMessage && break"

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
commandFactory["drop table"]="dropTable"

createTable() {
	echo -n "What is the name of the table? "
	read tableName

	declare -A arguments

	while true; do

		echo -n "What is the name of the next column? "
		read columnName

		echo -n "What is the definition of the column? "
		read columnDefinition
		arguments+=(["$columnName"]="$columnDefinition")

		echo -n "Are you done yet? [y/N] "
		read isDone

		if [[ $isDone == "y" || $isDone == "Y" ]]; then
			break
		fi
	done

	out=""

	for key in "${!arguments[@]}"; do
		out+="$key ${arguments[$key]},"
	done

	local cmd="CREATE TABLE $tableName (${out::-1});"

	printf "$cmd\n"
	echo -n "Would you like to run this command? "
	read doExec

	if [[ $doExec == "y" || $doExec == "Y" ]]; then
		psql -c "$cmd"
	fi
}

commands["create_table"]="creates a table if valid and does not exist yet"
commandFactory["create table"]="createTable && echo"

describeTable() {
	echo -n "Which table you wanna know more about? "
	read tableName

	psql -c "\d $tableName"
}

commands["describe_table"]="shows the internal structure of a given table"
commandFactory["describe table"]="describeTable && echo"


selectFromTable() {
	echo -n "Which table you wanna select? "
	read tableName

	echo -n "Should use where constraint? [y/N] "
	read useWhere

	if [[ $useWhere == "y" || $useWhere == "Y" ]]; then
	        echo -n "Tell me the where constraints: "
        	read whereConstraint
	fi

	echo -n "Wanna select certain columns only? [y/N] "
        read agree


	if [[ $agree == "y" || $agree == "Y" ]]; then
		echo -n "Tell me the columns separed by comma (,): "
		read columnNames

		if [[ $useWhere == "y" || $useWhere == "Y" ]]; then
	                psql -c "SELECT $columnNames FROM $tableName WHERE $whereConstraint;"
			return
		fi

		psql -c "SELECT $columnNames FROM $tableName;"
		return
	fi


	if [[ $useWhere == "y" || $useWhere == "Y" ]]; then
		psql -c "SELECT * FROM $tableName WHERE $whereConstraint;"
		return
	fi

	psql -c "SELECT * FROM $tableName;"
}

commands["select_table"]="get values from a table and shows on the screen"
commandFactory["select table"]="selectFromTable && echo"
