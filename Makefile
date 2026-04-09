BINARY_NAME  := terraform-provider-openmetadata
MODULE       := github.com/open-metadata/terraform-provider-openmetadata
VERSION     ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
COMMIT      ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "none")
LDFLAGS      := -s -w -X main.version=$(VERSION) -X main.commit=$(COMMIT)

OS           := $(shell go env GOOS 2>/dev/null || echo linux)
ARCH         := $(shell go env GOARCH 2>/dev/null || echo amd64)

# Terraform plugin directory
TF_PLUGIN_DIR := $(HOME)/.terraform.d/plugins/registry.terraform.io/open-metadata/openmetadata/$(VERSION)/$(OS)_$(ARCH)

.PHONY: build install clean fmt lint test docs codegen deps help

## Build the provider binary
build:
	CGO_ENABLED=0 go build -ldflags="$(LDFLAGS)" -o $(BINARY_NAME) .

## Build + install into the Terraform plugin directory
install: build
	mkdir -p $(TF_PLUGIN_DIR)
	cp $(BINARY_NAME) $(TF_PLUGIN_DIR)/$(BINARY_NAME)
	@echo "Installed to $(TF_PLUGIN_DIR)/$(BINARY_NAME)"

## Format Go code
fmt:
	go fmt ./...

## Run linter
lint:
	golangci-lint run ./...

## Run unit tests
test:
	go test -v -count=1 ./...

## Generate provider documentation (requires tfplugindocs)
docs:
	go generate ./...

## Generate a resource — use the AI codegen skill instead of this target.
## See: .github/skills/codegen/SKILL.md
codegen:
	@echo "Resource generation is now handled by the AI codegen skill."
	@echo "See: .github/skills/codegen/SKILL.md"
	@echo ""
	@echo "Ask your AI agent: 'Generate a TF resource for <entity>'"

## Resolve Go module dependencies
deps:
	go mod tidy

## Remove build artifacts
clean:
	rm -f $(BINARY_NAME)

## Show available targets
help:
	@echo "Available targets:"
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/## /  /'
	@echo ""
	@echo "Environment:"
	@echo "  VERSION=$(VERSION)"
	@echo "  OS=$(OS) ARCH=$(ARCH)"
