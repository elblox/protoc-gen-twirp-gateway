PROTOBUF := $(shell find _testdata -name '*.proto' | grep -v vendor)

.PHONY: test
test:
	docker build -t protoc-gen-twirp-gateway:latest -f Dockerfile .
	docker run -it --rm -v `pwd`/_testdata:/proto/_testdata protoc-gen-twirp-gateway:latest $(PROTOBUF)
	cd _testdata && go build . && rm main

.PHONY: clean
clean:
	rm -f _testdata/service.*.go
	rm -f _testdata/main
