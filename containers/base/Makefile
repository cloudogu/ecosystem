ALPINE_VERSION="3.7"
CHANGE_COUNTER="1"
IMAGE_TAG="$(ALPINE_VERSION)-$(CHANGE_COUNTER)"
IMAGE_NAME="registry.cloudogu.com/official/base"

default: build

.PHONY: info
info:
	@echo "version informations ..."
	@echo "Version       : $(VERSION)"
	@echo "Image Name    : $(IMAGE_NAME)"
	@echo "Image Tag     : $(IMAGE_TAG)"
	@echo "Image         : $(IMAGE_NAME):$(ALPINE_VERSION)-$(CHANGE_COUNTER)"

.PHONY: build
build:
	docker build -t "$(IMAGE_NAME):$(IMAGE_TAG)" .

.PHONY: deploy
deploy: build
	docker push "$(IMAGE_NAME):$(IMAGE_TAG)"

.PHONY: shell
shell: build
	docker run --rm -ti "$(IMAGE_NAME):$(IMAGE_TAG)" bash || 0
