#!/usr/bin/env bash


FILE_NAME="users.db"
RELATIVE_PATH_TO_USERS_DB="../data/$FILE_NAME"
RELATIVE_PATH_TO_DATA_FOLDER="../data"

if [[ -f $RELATIVE_PATH_TO_USERS_DB  ]]
	then echo "file users.db exist"
	else touch $RELATIVE_PATH_TO_USERS_DB
fi

function add {
	read -p "Enter user name " username
	
	if [[ ! $username =~ ^[A-Za-z][A-Za-z_]+$ ]]
		then
		echo "Please enter the name in latin format"
		exit 1
	fi
	
	read -p "Enter your role " userrole
	if [[ ! $userrole =~ ^[A-Za-z][A-Za-z_]+$ ]]
		then
		echo "Please enter the role in latin format"
		exit 1
	fi

echo "Username: $username, Role: $userrole"
echo "$username, $userrole" >> $RELATIVE_PATH_TO_USERS_DB
}

function help {
	echo 
	echo "add	add new line to users.db file"
	echo
	echo "backup	create backup file"
	echo
	echo "restore	restore the lastest backup file"
	echo
	echo "find 	find all users in DB according to key-word"
	echo
	echo "list 	print all users stored in DB in numerious list"
	echo
	echo "      --inverse	allows to inverse the list of users"
	echo
	echo
}

function backup {
	BACKUP_FILE_NAME=$(date +'%Y-%m-%d-%H-%M-%S')-users.db.backup
	cp -v $RELATIVE_PATH_TO_USERS_DB $RELATIVE_PATH_TO_DATA_FOLDER/$BACKUP_FILE_NAME 
	echo $BACKUP_FILE_NAME
}

function restore {
	cd "../data"	
	lastestBackupFile=$( ls -tU *.backup | tail -n 1)
	
	if [[ ! -f $lastestBackupFile  ]]
	then
	  echo "There is no file for backup"
	  exit 1
	fi

	cat $lastestBackupFile > "./$FILE_NAME"
}

function find {
	read -p "Enter searching name of user " username

	namesArray=$(grep -Rwi -E "$username[A-Za-z]*" $RELATIVE_PATH_TO_USERS_DB)

	if [[ ! $namesArray ]] 
	then 
		echo "User not found!"
		exit 1
	fi
	echo $namesArray
}

	
	inverse=$2
	
function list {
	if [[ $inverse == "--inverse" ]]
	then
		cat -n $RELATIVE_PATH_TO_USERS_DB | tac
	else
		cat -n $RELATIVE_PATH_TO_USERS_DB
	fi
}
case $1 in
	add) add;;
	help) help;;
	backup) backup;;
	restore) restore;;
	find) find;;
	list) list;;
	*) help;;
esac
