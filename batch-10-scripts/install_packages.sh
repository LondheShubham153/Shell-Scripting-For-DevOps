#!/bin/bash


echo "installing $1"

sudo apt-get update && sudo apt-get install $1 -y

echo "Successfully installed $1"
