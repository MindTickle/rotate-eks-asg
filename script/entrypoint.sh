#!/bin/sh
set -ex

# Render a AWS credentials with user and role for `awsudo`.
aws eks update-kubeconfig --name ${CLUSTER:?}
rotate-eks-asg ${AUTOSCALING_GROUPS:?}
