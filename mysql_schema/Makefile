APP_ENV ?= dev
IMAGE_TAG ?= mysql_schema

build:
	docker build . -f Dockerfile --target liquibase --tag ${IMAGE_TAG} .

update:
	docker run --rm ${IMAGE_TAG} update

rollback:
	docker run --rm ${IMAGE_TAG} rollback

.PHONY: update rollback
