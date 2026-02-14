#!/bin/bash

<< usage
- take user name as input
- take password as input
- check if user already exists
- create the user
usage

# function definition

create_user() {

read -p "enter the username" username
read -p "enter the password" password

if id "$username" &>/dev/null; then
    echo "The user $username exists, exiting the code."
    exit 1
else
    echo "The user $username does not exist and will be created ...."
fi

sudo useradd -m $username -p $password

echo "user $username added successfully"

}

