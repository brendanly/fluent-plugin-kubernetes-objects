#!/usr/bin/env bash
set -e
aws ecr get-login --region $AWS_REGION --no-include-email | bash
echo "Building docker image..."
cp pkg/fluent-plugin-kubernetes-objects-*.gem docker
docker build --no-cache -t splunk/fluent-plugin-kubernetes-objects:ci ./docker
docker tag splunk/fluent-plugin-kubernetes-objects:ci $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/k8s-ci-objects:latest
echo "Push docker image to ecr..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/k8s-ci-objects:latest | awk 'END{print}'
echo "Docker image pushed successfully."