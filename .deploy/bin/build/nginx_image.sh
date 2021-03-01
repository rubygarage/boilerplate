#!/bin/bash

set -e

source ".deploy/bin/variables.sh"

while [ $# -gt 0 ]
do
  key="$1"

  case $key in
    --running-tag)
      RUNNING_TAG="$2"
      shift
      shift
    ;;
    *)
      echo "Unknown option $1\n"
      shift
      shift
  esac
done

IMAGE_NAME="boilerplate-api/$RUNNING_TAG/web-server"
REPO="$ECR_ID.dkr.ecr.$REGION.amazonaws.com/$IMAGE_NAME"

HASH_TAG="$(git rev-parse --short HEAD)"

RUNNING_IMAGE=$REPO:$RUNNING_TAG
CURRENT_IMAGE=$IMAGE_NAME:$HASH_TAG

$(aws ecr get-login --region $REGION --no-include-email)

docker build --cache-from=$RUNNING_IMAGE -t $CURRENT_IMAGE ./.deploy/nginx

docker tag $CURRENT_IMAGE $REPO:$HASH_TAG
docker tag $CURRENT_IMAGE $RUNNING_IMAGE

docker push $REPO:$HASH_TAG
docker push $RUNNING_IMAGE
