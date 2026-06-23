#!/bin/bash

# Deploy a Django app and handle errors

# Function to clone the Django app code
clone() {
    echo "Cloning the Django app..."
        git clone https://github.com/LondheShubham153/django-notes-app.git 
        
}

# Function to install required dependencies
install() {
    echo "Installing dependencies..."
    sudo apt-get update && sudo apt-get install -y docker.io nginx docker-compose-v2
}

# Function to perform required restarts
restart() {
    echo "Performing required restarts..."
    #sudo chown "$USER" /var/run/docker.sock 
    }

    # Uncomment the following lines if needed:
    # sudo systemctl enable docker
    # sudo systemctl enable nginx
    # sudo systemctl restart docker
}

# Function to deploy the Django app
deploy() {
    echo "Building and deploying the Django app..."
    docker build -t notes-app . 
    docker run notes-app
    #docker compose up 
    
}

# Main deployment script
echo "********** DEPLOYMENT STARTED *********"

# Clone the code
if ! clone; then
echo "cloning failed"
    cd django-notes-app || exit 1
fi

# Install dependencies
if ! install; then
echo "install failed"
    exit 1
fi

# Perform required restarts
if ! restarts; then
echo"restart failed"
    exit 1
fi

# Deploy the app
if ! deploy; then
    echo "Deployment failed. Mailing the admin..."
    # Add your sendmail or notification logic here
    exit 1
fi

echo "********** DEPLOYMENT DONE *********"
