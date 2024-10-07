#!/bin/bash

# Create IAM role if not exists
ROLE_NAME="lambda-execution-role"
ROLE_POLICY_DOCUMENT="trust-policy.json"
ROLE_ARN=""

echo "Checking if IAM role exists..."
ROLE_ARN=$(aws iam get-role --role-name $ROLE_NAME --query 'Role.Arn' --output text 2>/dev/null --profile iamadmin-production)

if [ -z "$ROLE_ARN" ]; then
  echo "Creating IAM role..."
  aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://$ROLE_POLICY_DOCUMENT --profile iamadmin-production
  aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole --profile iamadmin-production
  ROLE_ARN=$(aws iam get-role --role-name $ROLE_NAME --query 'Role.Arn' --output text --profile iamadmin-production)
  echo "IAM role created: $ROLE_ARN"
else
  echo "IAM role already exists: $ROLE_ARN"
fi

# Function to deploy a Lambda function
deploy_lambda() {
  local lambda_name=$1
  local zip_file=$2

  echo "Deploying Lambda function: $lambda_name"
  aws lambda create-function --function-name $lambda_name \
    --zip-file fileb://$zip_file --handler index.handler --runtime nodejs20.x \
    --role $ROLE_ARN --profile iamadmin-production
}

# Loop through the current directory and deploy each Lambda function for .zip files
for zip_file in *.zip; do
  if [ -f "$zip_file" ]; then
    lambda_name="${zip_file%.zip}"
    deploy_lambda $lambda_name $zip_file
  fi
done

echo "Deployment completed."
