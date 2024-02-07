mq-client-sdk:
	@mkdir -p ./mq-client-sdk

mq-client-sdk/windows: mq-client-sdk
	@curl -o ./mq-client-sdk/windows.zip https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqdev/redist/9.3.4.1-IBM-MQC-Redist-Win64.zip; \
	mkdir -p ./mq-client-sdk/windows; \
	unzip ./mq-client-sdk/windows.zip -d ./mq-client-sdk/windows

mq-client-sdk/linux: mq-client-sdk
	@curl -o ./mq-client-sdk/linux.tar.gz https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/messaging/mqdev/redist/9.3.4.1-IBM-MQC-Redist-LinuxX64.tar.gz; \
	mkdir -p ./mq-client-sdk/linux; \
	tar -zxf ./mq-client-sdk/linux.tar.gz -C ./mq-client-sdk/linux

.PHONY: clean
clean:
	@rm -rf ./mq-client-sdk; \
	rm -rf ./bin/*
	
.PHONY: build-linux-amd64
build-linux-amd64: MQ_INSTALLATION_PATH = $(PWD)/mq-client-sdk/linux
build-linux-amd64: CGO_CFLAGS = -I${MQ_INSTALLATION_PATH}/inc
build-linux-amd64: CGO_LDFLAGS = "-L${MQ_INSTALLATION_PATH}/lib64 -Wl,-rpath=${MQ_INSTALLATION_PATH}/lib64"
build-linux-amd64: GOOS = linux
build-linux-amd64: GOARCH = amd64

build-linux-amd64: mq-client-sdk/linux
	mkdir -p ./bin; \
	GOOS=${GOOS} GOARCH=${GOARCH} CGO_CFLAGS=${CGO_CFLAGS} CGO_LDFLAGS=${CGO_LDFLAGS} go build -o ./bin/linux-amd64

.PHONY: build-windows-amd64
build-windows-amd64: MQ_INSTALLATION_PATH = $(PWD)/mq-client-sdk/windows
build-windows-amd64: CGO_CFLAGS = "-I${MQ_INSTALLATION_PATH}/tools/c/include -D_WIN64"
build-windows-amd64: CGO_LDFLAGS = "-L ${MQ_INSTALLATION_PATH}/bin64 -lmqm"
build-windows-amd64: GOOS = windows
build-windows-amd64: GOARCH = amd64

build-windows-amd64: mq-client-sdk/windows
	mkdir -p ./bin; \
	GOOS=${GOOS} GOARCH=${GOARCH} CGO_CFLAGS=${CGO_CFLAGS} CGO_LDFLAGS=${CGO_LDFLAGS} go build -o ./bin/windows-amd64.exe

.PHONY: build-darwin-arm64
build-darwin-arm64: GOOS = darwin
build-darwin-arm64: GOARCH = arm64

build-darwin-arm64:
	mkdir -p ./bin; \
	GOOS=${GOOS} GOARCH=${GOARCH} go build -o ./bin/darwin-arm64