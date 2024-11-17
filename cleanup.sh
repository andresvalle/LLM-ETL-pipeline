#!/bin/bash

# This values must match the ones used for creation
STACK_NAME="llm-etl"
REGION="us-east-1"

BUCKET=$(aws cloudformation describe-stacks --region $REGION \
                                   --stack-name $STACK_NAME \
                                   --query "Stacks[].Outputs[?OutputKey=='bucketName'].OutputValue" \
                                   --output text)

# Emptying the bucket
aws s3 rm s3://$BUCKET --recursive

# Destroying the stack
aws cloudformation delete-stack --stack-name $STACK_NAME \
                                --region $REGION
