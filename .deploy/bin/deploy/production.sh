#!/bin/bash

source ".deploy/bin/variables.sh"
source ".deploy/bin/deploy/base.sh"

IMAGE_NAME="boilerplate-api/production/server-app"

deploy \
  --region "$REGION" \
  --aws-access-key "$AWS_ACCESS_KEY_ID" \
  --aws-secret-key "$AWS_SECRET_ACCESS_KEY" \
  --image-name "$IMAGE_NAME" \
  --repo "$ECR_ID.dkr.ecr.$REGION.amazonaws.com/$IMAGE_NAME" \
  --cluster "boilerplate-api-production" \
  --service "boilerplate-api-production" \
  --running-tag "production" \
  --docker_file ".docker/production/Dockerfile"

deploy \
  --region "$REGION" \
  --aws-access-key "$AWS_ACCESS_KEY_ID" \
  --aws-secret-key "$AWS_SECRET_ACCESS_KEY" \
  --image-name "$IMAGE_NAME" \
  --repo "$ECR_ID.dkr.ecr.$REGION.amazonaws.com/$IMAGE_NAME" \
  --cluster "boilerplate-api-production" \
  --service "boilerplate-api-production-worker" \
  --running-tag "production" \
  --docker_file ".docker/production/Dockerfile" \
  --skip-build true
