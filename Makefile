
.PHONY: build-cpp
build-cpp:
	docker build -t llama.cpp:server -f .devops/cpu.Dockerfile .

.PHONY: build-cuda
build-cuda:
	docker build -t llama.cpp:server-cuda --target server -f .devops/cuda.Dockerfile .