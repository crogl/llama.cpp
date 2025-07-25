VERSION ?= 25.07.0

.PHONY: build-cpu build-cuda build-rocm build-all clean ecr-login push-cpu

build-cpu:
	@echo "🔧 Building lm-cpu:${VERSION}"
	docker build --no-cache -t lm-cpu:${VERSION} -f .devops/cpu.Dockerfile .

build-cuda:
	@echo "🔧 Building lm-cuda:${VERSION}"
	docker build --no-cache -t lm-cuda:${VERSION} -f .devops/cuda.Dockerfile .

build-rocm:
	@echo "🔧 Building lm-rocm:${VERSION}"
	docker build --no-cache -t lm-rocm:${VERSION} -f .devops/rocm.Dockerfile .

build-all: build-cpu build-cuda build-rocm

clean:
	@echo "🧹 Cleaning..."
	@docker builder prune -f
	@docker rmi lm-cpu:${VERSION} lm-cuda:${VERSION} lm-rocm:${VERSION} || true


ecr-login:
	@if [ -z "$$AWS_ACCOUNT_ID" ] || [ -z "$$AWS_REGION" ]; then \
		echo "❌ ERROR: AWS_ACCOUNT_ID and AWS_REGION must be set in the environment"; \
		exit 1; \
	fi
	@echo "🔐 Logging in to AWS ECR..."
	aws ecr get-login-password --region $$AWS_REGION \
		| docker login --username AWS --password-stdin $$AWS_ACCOUNT_ID.dkr.ecr.$$AWS_REGION.amazonaws.com
	@echo "✅ AWS ECR login successful"


push-cpu: ecr-login
	@echo "🚀 Pushing lm-cpu:${VERSION} to ECR repository 'crogl'..."
	docker tag lm-cpu:${VERSION} $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/crogl:lm-cpu-${VERSION}
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/crogl:lm-cpu-${VERSION}
	@echo "✅ Push complete: crogl:lm-cpu-${VERSION}"

push-cuda: ecr-login
	@echo "🚀 Pushing lm-cuda:${VERSION} to ECR repository 'crogl'..."
	docker tag lm-cuda:${VERSION} $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/crogl:lm-cuda-${VERSION}
	docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/crogl:lm-cuda-${VERSION}
	@echo "✅ Push complete: crogl:lm-cuda-${VERSION}"