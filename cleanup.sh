#!/bin/bash

STACK_NAME="llm-etl"
REGION="us-east-1"

BUCKET=$(aws cloudformation describe-stacks --region $REGION \
                                   --stack-name $STACK_NAME \
                                   --query "Stacks[].Outputs[?OutputKey=='bucketName'].OutputValue" \
                                   --output text)

aws s3 rm s3://$BUCKET --recursive

aws cloudformation delete-stack --stack-name $STACK_NAME \
                                --region $REGION
