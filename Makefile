CURRENT_DIRECTORY := $(shell pwd)

build:
	@docker build --tag=iiiepe/nginx-drupal $(CURRENT_DIRECTORY)

.PHONY: build

