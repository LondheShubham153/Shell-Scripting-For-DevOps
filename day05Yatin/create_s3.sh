#!/bin/bash

set -euo pipefail

<< TASK
NAME: YATIN
TASK: CREATE S3 BUCKET USING SHELL SCRIPT
TASK

check_awscli(){
if ! command -v aws &> /dev/null; then
	echo "AWS CLI not installed, Installing it"
	install_awscli
else
	echo "AWS CLI INSTALLED!"
fi
}

install_awscli(){
# Download and install AWS CLI v2
	curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    	sudo apt-get install -y unzip &> /dev/null
    	unzip -q awscliv2.zip
    	sudo ./aws/install

    # Verify installation
    	aws --version

    # Clean up
    	rm -rf awscliv2.zip ./aws
}

create_s3_bucket(){
	BUCKET_NAME=$1
	REGION=$2
	aws s3 mb s3://$BUCKET_NAME --region $REGION
	echo -e "------------------\nS3 Bucket $BUCKET_NAME created Successfully!!\n-------------------------"
}

main(){
	BUCKET_NAME="yatins-bucket"
	REGION="us-east-1"
	
	check_awscli
	if aws s3api head-bucket --bucket "$BUCKET_NAME" &> /dev/null; then
		echo -e "-----------------------------\nBucket $BUCKET_NAME already exists. Skipping creation.\n----------------------------"
	else
		echo "Creating Bucket in region $REGION"
		create_s3_bucket $BUCKET_NAME $REGION
	fi
}

main
