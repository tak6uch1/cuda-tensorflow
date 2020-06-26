IMAGE=tak6uch1/tensorflow_jupyter
VERSION=latest
CONTAINER=tensorflow_jupyter
USER=user

build:
	docker build -t $(IMAGE):$(VERSION) .

restart: stop rm run

uid=`id -u $(USER)`
ugrp=`id -g $(USER)`

run:
	docker run \
		--gpus '"device=0"' \
		-itd \
		-p 8888:8888 \
		-v /etc/group:/etc/group:ro \
		-v /etc/passwd:/etc/passwd:ro \
		-v /home/user/work/cuda-tensorflow/work:/work \
                -v /home/user/work/cuda-tensorflow/notebooks:/opt/notebooks \
		-u $(uid):$(ugrp) \
		--name $(CONTAINER) \
		$(IMAGE)

run_root:
	docker run \
		--gpus '"device=0"' \
		-itd \
		-p 8888:8888 \
                -v /home/user/work/cuda-tensorflow/notebooks:/opt/notebooks \
		--name $(CONTAINER) \
		$(IMAGE)

container=`docker ps -a | grep $(CONTAINER) | awk '{print $$1}'`
image=`docker images | grep $(IMAGE) | grep $(VERSION) | awk '{ print $$3 }'`

clean: rm
	if [ "$(image)" != "" ] ; then \
		docker rmi $(image); \
	fi

rm:
	if [ "$(container)" != "" ] ; then \
		docker rm -f $(container); \
	fi

stop:
	if [ "$(container)" != "" ] ; then \
		docker stop $(container); \
	fi

exec:
	docker exec -u $(uid):$(ugrp) -it $(CONTAINER) bash

exec_root:
	docker exec -it $(CONTAINER) bash

logs:
	docker logs $(CONTAINER)
