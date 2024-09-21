#! /bin/bash
#Create s3 bucket for terraform state
aws s3api create-bucket --bucket rndm-smpl-tf-state-bucket --region eu-west-2 --create-bucket-configuration LocationConstraint=eu-west-2
#enable versoning
aws s3api put-bucket-versioning --bucket rndm-smpl-tf-state-bucket --versioning-configuration Status=Enabled
#create dynamodb table for state lock
aws dynamodb create-table --table-name rndm-smpl-tf-state-table \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST