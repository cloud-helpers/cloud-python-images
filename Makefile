#
# File: https://github.com/cloud-helpers/cloud-python-images/blob/main/Makefile
# 

# Docker Hub organization
DCK_ORG := infrahelpers
DCK_PRJ := cloud-python
DCK_REPO := $(DCK_ORG)/$(DCK_PRJ)

# Today's date
TODAY_DATE := $(shell date '+%Y%m%d')
EXTRACT_DATE := $(TODAY_DATE)

# Current Debian release (https://www.debian.org/releases)
DEBIAN_REL := trixie

# Python (minor) versions
PY_VERSION_PATHS := $(wildcard python-*-$(DEBIAN_REL))
PY_VERSIONS := $(patsubst python-%-$(DEBIAN_REL),%,$(PY_VERSION_PATHS))
BUILD_IMGS := $(patsubst %,build-img-%,$(PY_VERSIONS))
PULL_IMGS := $(patsubst %,pull-img-%,$(PY_VERSIONS))
RUN_IMGS := $(patsubst %,run-img-%,$(PY_VERSIONS))
PUSH_IMGS := $(patsubst %,push-img-%,$(PY_VERSIONS))
BUILD_PUSH_IMGS := $(patsubst %,build-push-img-%,$(PY_VERSIONS))

.PHONY: help $(BUILD_IMGS) $(PULL_IMGS) $(RUN_IMGS) $(PUSH_IMGS) $(BUILD_PUSH_IMGS)

help: ## Display the help menu.
	@grep -h "\#\#" $(MAKEFILE_LIST)


$(BUILD_IMGS): build-img-%: ## Build the container image
	@py_version="$*" && \
	docker build -t $(DCK_REPO):$${py_version} python-$${py_version}-$(DEBIAN_REL)/

$(PULL_IMGS): pull-img-%: ## Pull the container image
	@py_version="$*" && \
	docker pull $(DCK_REPO):$${py_version}

$(RUN_IMGS): run-img-%: ## Run the container image
	@py_version="$*" && \
	docker run --rm -it $(DCK_REPO):$${py_version} bash

$(PUSH_IMGS): push-img-%: ## Publish the container image
	@py_version="$*" && \
	docker push $(DCK_REPO):$${py_version}

$(BUILD_PUSH_IMGS): build-push-img-%: build-img-% push-img-% ## Build and push the container image

