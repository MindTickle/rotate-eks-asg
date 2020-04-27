FROM golang:latest as buildenv
WORKDIR /go/src/github.com/MindTickle/rotate-eks-asg
COPY . .
RUN go clean -modcache
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /rotate-eks-asg ./cmd/rotate-eks-asg
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /rotate-eks-instance ./cmd/rotate-eks-instance

# Extract and ship with rest of tooling:

FROM python:3-alpine
RUN apk add --no-cache git
RUN pip install -q git+https://github.com/MindTickle/awsudo.git

# https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html
ARG AWSAUTHENTICATOR_URL=https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator

# https://kubernetes.io/docs/tasks/tools/install-kubectl
ARG KUBECTL_VERSION=1.14.0
ARG KUBECTL_URL=https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl

ADD ${KUBECTL_URL} /usr/local/bin/kubectl
ADD ${AWSAUTHENTICATOR_URL} /usr/local/bin/aws-iam-authenticator

RUN chmod +x \
    /usr/local/bin/kubectl \
    /usr/local/bin/aws-iam-authenticator

COPY --from=buildenv /rotate-eks-asg /usr/local/bin/
COPY --from=buildenv /rotate-eks-instance /usr/local/bin/
ADD ./script ./script

ENTRYPOINT ["./script/entrypoint.sh"]
