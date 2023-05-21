BUILD_DIR=$(shell PWD)/build
JAVA_INFO_SRC=$(shell PWD)/metadata-extractor/JvmMetadataExtractor.java
JAVA_BUILD_DIR=$(BUILD_DIR)/classes
JAVA_INFO_CLASS=$(JAVA_BUILD_DIR)/JvmMetadataExtractor.class
JVM_FINDER_SOURCES=$(shell PWD)/jvm-finder
GO_BUILD_DIR=$(BUILD_DIR)/go
MAIN_PROGRAM=$(GO_BUILD_DIR)/jvm-finder
SOURCES := $(shell find $(JVM_FINDER_SOURCES) -name '*.go')

.PHONY: all
all: format test build

.PHONY: clean
clean:
	rm  -rf "$(BUILD_DIR)"

.PHONY: build
build: $(JAVA_INFO_CLASS) $(MAIN_PROGRAM)

$(JAVA_INFO_CLASS): $(JAVA_INFO_SRC)
	@mkdir -p "$(JAVA_BUILD_DIR)"
	javac --release 8 -d "$(JAVA_BUILD_DIR)" $(JAVA_INFO_SRC)

$(MAIN_PROGRAM): $(SOURCES)
	@mkdir -p "$(GO_BUILD_DIR)"
	cd $(JVM_FINDER_SOURCES) && go build -ldflags "-s -w" -o "$(GO_BUILD_DIR)" ./...

.PHONY: format
format: $(SOURCES)
	cd $(JVM_FINDER_SOURCES) && go fmt ./...

.PHONY: test
test: $(JAVA_INFO_CLASS) $(SOURCES)
	cd $(JVM_FINDER_SOURCES) && go test ./...
