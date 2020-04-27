all: test
docker:
	docker build -t rotate-eks-asg .
deps:
	GO111MODULE=on go build ./cmd/...
	GO111MODULE=on go mod tidy
	GO111MODULE=on go mod vendor
install:
	GO111MODULE=on go install -mod=vendor ./cmd/rotate-eks-asg
	GO111MODULE=on go install -mod=vendor ./cmd/rotate-eks-instance
docker_build:
	docker build -t 191195949309.dkr.ecr.ap-southeast-1.amazonaws.com/devops/rotate-eks-asg:latest .
docker_push:
	aws ecr get-login --no-include-email --region ap-southeast-1 | sh -
	docker push 1191195949309.dkr.ecr.ap-southeast-1.amazonaws.com/devops/rotate-eks-asg:latest
