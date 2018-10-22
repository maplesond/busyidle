
# Vars

REG=danacr.azurecr.io
NAME=busyidle
VERSION=4
IMG=$(REG)/$(NAME):$(VERSION)

all: image gooddeploy

# Building targets

compile: $(NAME).cpp
	g++ -static -std=c++17 -o $(NAME) $(NAME).cpp

image: $(NAME)
	docker build --tag $(IMG) . && \
	docker tag $(IMG) $(REG)/$(NAME):latest && \
	docker push $(IMG) && \
	docker push $(REG)/$(NAME):latest

runlocal:
	./$(NAME)

runcontainer:
	docker run -it $(IMG)


# Cleanup targets

cleanall: undeploy cleanimage clean 

clean:
	rm $(NAME)

cleanimage:
	docker rmi $(IMG)


# Deployment targets

deploy:
	helm install -f helm/busyidle/values.yaml --name busyidle-nolimit ./helm/busyidle

gooddeploy:
	helm install -f helm/busyidle/values_good.yaml --name busyidle-limited ./helm/busyidle

scale:
	kubectl scale deployment --replicas=20 busyidle-nolimit

goodscale:
	kubectl scale deployment --replicas=20 busyidle-limited

undeploy:
	helm delete --purge busyidle-nolimit

goodundeploy:
	helm delete --purge busyidle-limited


# Monitoring targets

browse:
	az aks browse --resource-group danaks --name dan-aks

monitor:
	google-chrome 168.63.45.64:15031


# Presentation

presentation:
	google-chrome presentation.html
	
