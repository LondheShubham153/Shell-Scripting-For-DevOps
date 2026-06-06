#!/bin/bash


<< task
deploy django app
and handle errors
task


#Function to clone the django app
code_clone(){

        echo "Cloning the Django app..."
        git clone https://github.com/LondheShubham153/django-notes-app.git
}

#Function to install required dependencies
install_req() {

        echo " Installing dependencies..."
        sudo apt-get install docker.io nginx -y docker-compose
}

#Function to perform required restarts
req_restarts() {

        echo "Performing required restarts"

        sudo chown $USER /var/run/docker.sock
        #sudo systemctl enable docker
        #sudo systemctl enable nginx
        #sudo systemctl restart docker
}

#Fucntion to deploy Django app
deploy(){
        echo "Building and Deploying Django app..."    #Fixed deployment : Old networks from previous runs had different settings, causing the new deployment to crash.
	                                               #Added docker-compose down to the start of the deploy function to wipe the slate clean.
        docker-compose down
        docker build -t notes-app .
        docker-compose up -d
}

echo "***************** DEPLOYMENT STARTED ******************"

if ! code_clone;
then
        echo "directory already exists, skipping cloning...."
fi

#Moved cd outside the logic so it always enters the app folder before building.
 cd django-notes-app || { echo "Failed to enter directory" ; exit 1; }


if ! install_req;
then
        echo "Failed to install requirements"
        exit 1
fi


if ! req_restarts;
then
        echo "System fault identitfied"
        exit 1
fi

if ! deploy;
then
        echo "Deployment Failed"
        # sendmail
        exit 1
fi

echo "***************** DEPLOYMENT DONE ******************"
