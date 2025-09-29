docker-repository := kargoglobal/awscli
tag := v2
image-tag := $(docker-repository):$(tag)

docker-context-%: instance-id = $(shell aws ec2 describe-instances --filters Name=tag:Name,Values=remote-docker-$* --query 'Reservations[].Instances[].InstanceId' --output text)
docker-context-%:
	docker context create remote-docker-$* --docker host=ssh://ubuntu@$(instance-id) || \
	docker context update remote-docker-$* --docker host=ssh://ubuntu@$(instance-id)

docker-build: docker-context-arm64 docker-context-amd64
	( \
		docker --context=remote-docker-arm64 build --tag=$(image-tag)-arm64 . && \
		docker --context=remote-docker-arm64 push $(image-tag)-arm64 \
	)& \
	( \
		docker --context=remote-docker-amd64 build --tag=$(image-tag) . && \
		docker --context=remote-docker-amd64 push $(image-tag) \
	)& \
	wait

docker-push: docker-build
	docker buildx imagetools create --tag $(image-tag) --append $(image-tag)-arm64
