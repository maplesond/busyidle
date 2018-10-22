
# Vars

REG=danacr.azurecr.io
NAME=busyidle
VERSION=4
IMG=$(REG)/$(NAME):$(VERSION)
HELM_DIR=helm/busyidle


# Building targets

$(NAME): $(NAME).cpp
	g++ -static -std=c++17 -o $(NAME) $(NAME).cpp

build: $(NAME)
	docker build --tag $(IMG) . && \
	docker tag $(IMG) $(REG)/$(NAME):latest && \
	docker push $(IMG) && \
	docker push $(REG)/$(NAME):latest


# Run targets

runlocal:
	./$(NAME)

runcontainer:
	docker run -it $(IMG)


# Cleanup targets

clean:
	rm $(NAME); docker rmi $(IMG)


# Deployment targets

$(HELM_DIR)/values_limited.yaml: $(HELM_DIR)/values_limited_template.yaml
	sed 's/VERSION/$(VERSION)/g' $(HELM_DIR)/values_limited_template.yaml > $(HELM_DIR)/values_limited.yaml

$(HELM_DIR)/values_nolimit.yaml: $(HELM_DIR)/values_nolimit_template.yaml
	sed 's/VERSION/$(VERSION)/g' $(HELM_DIR)/values_nolimit_template.yaml > $(HELM_DIR)/values_nolimit.yaml

deploy: $(HELM_DIR)/values_nolimit.yaml
	helm install -f $(HELM_DIR)/values_nolimit.yaml --name busyidle-nolimit ./helm/busyidle

gooddeploy: $(HELM_DIR)/values_limited.yaml
	helm install -f $(HELM_DIR)/values_limited.yaml --name busyidle-limited ./helm/busyidle

scale:
	kubectl scale deployment --replicas=20 busyidle-nolimit

goodscale:
	kubectl scale deployment --replicas=20 busyidle-limited

undeploy:
	helm delete --purge busyidle-nolimit; rm $(HELM_DIR)/values_nolimit.yaml

goodundeploy:
	helm delete --purge busyidle-limited; rm $(HELM_DIR)/values_limited.yaml


# Monitoring targets

browse:
	az aks browse --resource-group danaks --name dan-aks

monitor:
	google-chrome 168.63.45.64:15031


# Presentation

presentation:
	google-chrome presentation.html
	
