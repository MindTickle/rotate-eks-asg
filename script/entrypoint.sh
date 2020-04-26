#!/bin/sh
set -ex

# Render a AWS credentials with user and role for `awsudo`.
DEFAULT_REGION=ap-southeast-1
REGION=${REGION:-${DEFAULT_REGION}}

export KUBECONFIG=/tmp/.kube/config
awsudo -u role aws eks update-kubeconfig --name ${CLUSTER:?}
awsudo -u role rotate-eks-asg ${AUTOSCALING_GROUPS:?}
