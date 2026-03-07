#!/bin/bash

clone() {
        git clone https://github.com/LondheShubham153/django-notes-app.git 
}

install() {
    sudo apt-get update && sudo apt-get install -y docker.io nginx docker-compose-v2
}

restarts() {
    sudo chown "$USER" /var/run/docker.sock 
    sudo systemctl enable docker
    sudo systemctl enable nginx
    sudo systemctl restart docker
}

deploy() {
    docker build -t notes-app . 
    dockercompose up 

if ! clone; then
    cd django-notes-app || exit 1
fi

if ! install; then
    exit 1
fi

if ! restarts; then
    exit 1
fi

if ! deploy; then
       # Add your sendmail or notification logic here
    exit 1
fi

echo "********** DEPLOYMENT DONE *********"
