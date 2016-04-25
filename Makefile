# ISSUE: Make is not installed in drone container

REPO := $(shell git config --local remote.origin.url | sed -e 's/\.git$$//' -e 's,.*:,,')
ifeq ($(REPO),)
	REPO := $(shell basename $(shell pwd))
endif
VERSION := $(shell git branch | awk '{print $$2}')
ifeq ($(VERSION),)
	VERSION := 'sandbox'
endif
TAG := $(REPO):$(VERSION)
uid := $(shell id -u)
gid := $(shell id -g)
pwd := $(shell pwd)

.PHONY: all
all: build run

.PHONY: show
show:
	@echo REPO = $(REPO)
	@echo VERSION = $(VERSION)
	@echo TAG = $(TAG)
	@echo uid = $(uid)
	@echo gid = $(gid)

.PHONY: build
build: build-container

.PHONY: build-container
build-container:
	@echo REPO = $(REPO)
	@echo TAG = $(TAG)
	docker build --build-arg http_proxy=$(http_proxy) --build-arg https_proxy=$(https_proxy) --build-arg no_proxy=$(no_proxy) --tag=$(TAG) .

.PHONY: run
run:
	docker run --rm -u $(uid):$(gid) -v $(pwd):$(pwd) --workdir=$(pwd) $(TAG)
