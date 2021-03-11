#!/bin/sh

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

	[ $shouldDelete = "y" ] || [ $shouldDelete = "Y" ] && psql -c "DROP TABLE $tableName;"

}

commands["drop_table"]="deletes a table if it exists"
commandFactory["drop table"]="dropTable"

createTable() {
	echo -n "What is the name of the table? "
	read tableName

	declare -A arguments

	while : ; do

		echo -n "What is the name of the next column? "
		read columnName

		echo -n "What is the definition of the column? "
		read columnDefinition
		arguments+=(["$columnName"]="$columnDefinition")

		echo -n "Are you done yet? [y/N] "
		read isDone

		[ $isDone = "y" ] || [ $isDone = "Y" ] && break

	done

	out=""

	for key in "${!arguments[@]}"; do
		out+="$key ${arguments[$key]},"
	done

	local cmd="CREATE TABLE $tableName (${out::-1});"

	printf "$cmd\n"
	echo -n "Would you like to run this command? "
	read doExec

	[ $doExec = "y" ] || [ $doExec = "Y" ] && psql -c "$cmd"
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

	if [ $useWhere = "y" ] || [ $useWhere = "Y" ]; then
	        echo -n "Tell me the where constraints: "
        	read whereConstraint
	fi

	echo -n "Wanna select certain columns only? [y/N] "
        read agree


	if [ $agree = "y" ] || [ $agree = "Y" ]; then
		echo -n "Tell me the columns separed by comma (,): "
		read columnNames

		if [ $useWhere = "y" ] || [ $useWhere = "Y" ]; then
	                psql -c "SELECT $columnNames FROM $tableName WHERE $whereConstraint;"
			return
		fi

		psql -c "SELECT $columnNames FROM $tableName;"
		return
	fi


	if [ $useWhere = "y" ] || [ $useWhere = "Y" ]; then
		psql -c "SELECT * FROM $tableName WHERE $whereConstraint;"
		return
	fi

	psql -c "SELECT * FROM $tableName;"
}

commands["get"]="get values from a table and shows on the screen"
commandFactory["get"]="selectFromTable && echo"

addInTable() {
	echo -n "In which table you wanna add? "
	read tableName

	echo -n "What columns you wanna add separated by comma (,): "
	read columnNames

	echo -n "Type the values you wanna add in the same order you said in the columns separated by comma (,): "
	read valuesToAdd

	local cmd="INSERT INTO $tableName($columnNames) VALUES ($valuesToAdd);"

	echo $cmd
	echo -n "Are you sure you wanna add this? [y/N]"
	read areYouSure

	[ $areYouSure = "y" ] || [ $areYouSure = "Y" ] && psql -c "$cmd"
}

commands["add"]="Insert in a table a values for given columns"
commandFactory["add"]="addInTable && echo"

deleteFromTable() {
	echo -n "From what table you wanna delete? "
	read tableName

	echo -n "Tell me the where constraint: "
	read whereConstraint

	local cmd="DELETE FROM $tableName WHERE $whereConstraint;"
	echo $cmd

	echo -n "Are you sure you wanna execute this delete? [y/N]"
	read areYouSure

	[ $areYouSure = "y" ] || [ $areYouSure = "Y" ] && psql -c "$cmd"
}

commands["delete"]="Delete something from a table given some where constraints"
commandFactory["delete"]="deleteFromTable && echo"


updateValue() {
	echo -n "Tell me from what table you wanna update? "
	read tableName

	echo -n "Tell me what columns and value separated by (,) you wanna update: "
	read updatedValues

	echo -n "Now the where clause: "
	read whereClause

	local cmd="UPDATE $tableName SET $updatedValues WHERE $whereClause;"
	echo $cmd

	echo -n "Are you sure you wanna update with this command? [y/N]"
	read areYouSure

	[ $areYouSure = "y" ] || [ $areYouSure = "Y" ] && psql -c "$cmd"
}

commands["update"]="Update values from a table given a where contraint"
commandFactory["update"]="updateValue && echo"

rawQuery() {
	TMP_FILENAME=tmp$((1 + $RANDOM % 10000)).sql
	eval $CODE_EDITOR $TMP_FILENAME

	sleep 5
	echo -n "Do you wanna execute the query written? [y/N]"
	read areYouSure

	if [ $areYouSure = "y" ] || [ $areYouSury = "Y" ]; then
		psql -f $TMP_FILENAME

		echo -n "Do you wanna save your sql script? [y/N]"
		read wantSave

		if [ $wantSave = "y" ] || [ $wantSave = "Y" ]; then 
			echo -n "What name you wanna call your script? "
			read scriptName

			mkdir -p ./scripts > /dev/null 2>&1

			mv $TMP_FILENAME ./scripts/$scriptName
			return
		fi

		rm $TMP_FILENAME
		return
	fi

	rm $TMP_FILENAME
}

commands["raw_query"]="Runs a raw query writen by the user"
commandFactory["raw query"]="rawQuery && echo"
