#!/bin/bash

STACK_NAME="llm-etl"
REGION="us-east-1"

aws cloudformation deploy --template-file cfnStack.yaml \
                          --stack-name $STACK_NAME \
                          --capabilities  CAPABILITY_NAMED_IAM \
                          --region $REGION \
                          --tags environment=testing

BUCKET=$(aws cloudformation describe-stacks --region $REGION \
                                   --stack-name $STACK_NAME \
                                   --query "Stacks[].Outputs[?OutputKey=='bucketName'].OutputValue" \
                                   --output text)

aws s3 cp ./sample_datasets s3://$BUCKET --recursive