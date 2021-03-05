#!/bin/bash

source ".deploy/bin/variables.sh"
source ".deploy/bin/deploy/base.sh"

IMAGE_NAME="boilerplate-api/staging/server-app"

deploy \
  --region "$REGION" \
  --aws-access-key "$AWS_ACCESS_KEY_ID" \
  --aws-secret-key "$AWS_SECRET_ACCESS_KEY" \
  --image-name "$IMAGE_NAME" \
  --repo "$ECR_ID.dkr.ecr.$REGION.amazonaws.com/$IMAGE_NAME" \
  --cluster "boilerplate-api-staging" \
  --service "boilerplate-api-staging" \
  --running-tag "staging" \
  --docker_file ".docker/staging/Dockerfile"
