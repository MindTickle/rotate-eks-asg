#!/bin/sh
set -ex

# Render a AWS credentials with user and role for `awsudo`.
DEFAULT_REGION=ap-southeast-1
REGION=${REGION:-${DEFAULT_REGION}}

DEFAULT_PROFILE=default
PROFILE=${PROFILE:-${DEFAULT_PROFILE}}

export KUBECONFIG=/tmp/.kube/config

aws eks update-kubeconfig --name ${CLUSTER:?}
rotate-eks-asg ${AUTOSCALING_GROUPS:?}
