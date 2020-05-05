#!/bin/sh
set -ex

# Render a AWS credentials with user and role for `awsudo`.
aws eks update-kubeconfig --name ${CLUSTER:?} --profile ${AWS_PROFILE:?}

if [[ "$AWS_PROFILE" == "dev" ]]; then
    sed -i 's/value: dev/value: default/g' ~/.kube/config
fi
rotate-eks-asg ${AUTOSCALING_GROUPS:?}
