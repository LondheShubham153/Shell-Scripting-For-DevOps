#!/bin/bash

<< usage

./function.sh hello

inside function call

install_package docker.io

usage


echo "$1 is the main argument passed to the script"

haldi() {

	echo "haldi lagao"
	echo "pani me daal do"

}

# function define

install_package() {

	echo "$1 is the local argument passed to function"

sudo apt-get install $1
}


install_package docker.io # function call

