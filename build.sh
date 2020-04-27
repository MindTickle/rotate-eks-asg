#!/bin/bash

push="false"
version="latest"

for i in "$@"
do
  case $i in
    --version=*)
      version="${i#*=}"
      shift # past argument=value
    ;;
    --push)
      push="true"
      shift # past argument=value
    ;;
    *)
      # ignore
      shift # past argument=value
    ;;
  esac
done

echo "Building version '$version'"
set -ex
docker build -t rotate-eks-asg:$version .
if [[ $push == "true" ]]; then
  docker tag rotate-eks-asg:$version 191195949309.dkr.ecr.ap-southeast-1.amazonaws.com/devops/rotate-eks-asg:$version
  aws ecr get-login --no-include-email --region ap-southeast-1 | sh -
  docker push 191195949309.dkr.ecr.ap-southeast-1.amazonaws.com/devops/rotate-eks-asg:$version
fi
set +ex