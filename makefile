VERSION := ${CI_PIPELINE_ID}

ifneq ($(FILE),)
	COMPOSE_FILE := -f $(FILE)
else
	COMPOSE_FILE :=
endif

.PHONY: build
build:
	$(BASH)s2i build -e JAR_NAME=${JAR_NAME} -e INCREMENTAL=false ${PATH} iagtech/s2i-springboot:2.0.0-public ${SERVICE_REGISTRY}

.PHONY: compose
compose:
	$(BASH)docker rmi composed-greetingapi || true
	$(BASH)s2i build -e JAR_NAME=${JAR_NAME} -e INCREMENTAL=false ./greetingapi iagtech/s2i-springboot:2.0.0-public composed-greetingapi
	$(BASH)docker-compose $(COMPOSE_FILE) up -d
	
.PHONY: push
push:
	echo "VERSION=${VERSION}"
	docker tag ${CONTAINER_SERVICE_IMAGE} ${CONTAINER_SERVICE_IMAGE}:${VERSION}
	# $(BASH)jfrog rt config --url=${ARTIFACTORY_URL} --user=${ARTIFACTORY_USER} --password=${ARTIFACTORY_PASS}
	# $(BASH)jfrog rt c show
	# $(BASH)jfrog rt dp ${CONTAINER_SERVICE_IMAGE}:${VERSION} ${DOCKER_REPO_KEY} --build-name=${BUILD_NAME} --build-number=${CI_PIPELINE_ID}
	# $(BASH)jfrog rt bce ${BUILD_NAME} ${CI_PIPELINE_ID}
	# $(BASH)jfrog rt bp ${BUILD_NAME} ${CI_PIPELINE_ID}
	docker login -u ${ARTIFACTORY_USER} -p ${ARTIFACTORY_PASS}
	docker push ${CONTAINER_SERVICE_IMAGE}
	docker logout
                                                                                                                                                               
deploy:
	@oc describe -f ${DEPLOYMENT_FILE} && ([ $$? -eq 0 ] && oc replace -f ${DEPLOYMENT_FILE}) || ( oc create -f ${DEPLOYMENT_FILE} || echo "DEPLOYMENT REPLACED." )