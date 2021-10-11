PLATFORMS = linux/amd64,linux/i386,linux/arm64,linux/arm/v7
builder = xbuilder

comma := ,

ifeq ($(REPO),)
  REPO = dock-tex
endif
ifeq ($(CIRCLE_TAG),)
	TAG = latest
else
	TAG = $(CIRCLE_TAG)
endif

ifeq ($(CI),)
  dockerlogin =
	dockerargs = --platform $(firstword $(subst $(comma), ,$(PLATFORMS))) \
	             --load
	dockerlogout =
else
  dockerlogin = @docker login -u $(DOCKER_USER) -p $(DOCKER_PASS)
  dockerargs = --progress plain \
	             --platform $(PLATFORMS) \
	             --push
	dockerlogout = @docker logout
endif

.PHONY: init clean .FORCE
.FORCE:

all: init build clean

init: clean
	@docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
	@docker context create $(builder)
	@docker buildx create --name $(builder) --name $(builder) --driver docker-container --use
	@docker buildx inspect --bootstrap

%.dockerfile: .FORCE
	$(dockerlogin)
	docker buildx build \
			--build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
			--build-arg VCS_REF=$(shell git rev-parse --short HEAD) \
			--build-arg VCS_URL=$(shell git config --get remote.origin.url) \
			--build-arg VERSION=$(VERSION) \
			$(dockerargs) \
			--file $@ \
			-t $(REPO):$(basename $@) .
	$(dockerlogout)

build: init $(wildcard *.dockerfile)

clean:
	@docker buildx rm $(builder) | true
	@docker context rm $(builder) | true
