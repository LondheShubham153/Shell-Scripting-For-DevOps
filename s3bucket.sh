#!/bin/bash

aws_cli(){
if ! command -v aws &>  /dev/null; then
	echo "AWS CLI is not installed"
       echo "Installing AWS CLI"
	sudo apt update
	sudo apt install awscli
	echo "AWS CLI is successfully installed."
else
	echo "AWS CLI is already installed and version is"
	aws --version
	return 1
fi
}


create_s3(){
	local name=$1
	local region=$2
	local bucket_config_arg
#AWS CLI command to create s3 bucket
	s3=$(aws s3api create-bucket \
		--bucket $name \
		--region $region \
       		--create-bucket-configuration LocationConstraint=$region)

	if (bucket_exists "$name"); then
    exit 1
  fi

#If we want to create bucket outside us-east-1 location, otherwise you will get error of (IllegalLocationConstraintException)

if [[ "$region" != "us-east-1" ]]; then
    bucket_config_arg="--create-bucket-configuration LocationConstraint=$region"
  fi
  
}

bucket_exists(){

 aws s3api head-bucket --bucket $name --region $region 2>/dev/null
	return 1
}

main(){
aws_cli
echo "Creating s3 bucket"
name="lastshell22"
region="eu-west-2"
create_s3 $name $region
bucket_exists
}

main
