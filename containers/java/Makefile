# at the moment we could not upgrade to java version 8u131 on alpine 3.6, because of a bug
# in the alpine package. The bug affects the chart rendering of jenkins. We have to wait until
# alpine 3.6.3 was released.
# - https://bugs.alpinelinux.org/issues/7372
# - https://github.com/jenkinsci/docker/issues/508

JAVA_VERSION="8u151"
CHANGE_COUNTER="3"
JAVA_ALPINE_VERSION="8.151.12-r0"
IMAGE_NAME="registry.cloudogu.com/official/java"
IMAGE_TAG="$(JAVA_VERSION)-$(CHANGE_COUNTER)"

default: build

.PHONY: info
info:
	@echo "version informations ..."
	@echo "Java Version  : $(JAVA_VERSION)"
	@echo "Change Counter: $(CHANGE_COUNTER)"
	@echo "Apk Version   : $(JAVA_ALPINE_VERSION)"
	@echo "Image Name    : $(IMAGE_NAME)"
	@echo "Image Tag     : $(IMAGE_TAG)"
	@echo "Image         : $(IMAGE_NAME):$(IMAGE_TAG)"

.PHONY: build
build:
	docker build --build-arg JAVA_ALPINE_VERSION="$(JAVA_ALPINE_VERSION)" -t "$(IMAGE_NAME):$(IMAGE_TAG)" .

.PHONY: deploy
deploy: build
	docker push "$(IMAGE_NAME):$(IMAGE_TAG)"

.PHONY: shell
shell: build
	docker run --rm -ti "$(IMAGE_NAME):$(IMAGE_TAG)" bash || 0
