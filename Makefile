#Filenames
DEV_COMPOSE_FILE := dev/docker-compose.yaml
REL_COMPOSE_FILE := release/docker-compose.yaml

#Project Variable
PROJECT_NAME ?= todobackend 
REL_PROJECT := $(PROJECT_NAME)$(BUILD_ID)
DEV_PROJECT := $(addsuffix dev,$(REL_PROJECT))

.PHONY: test build release clean

test:
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) build
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up agent
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up test
build:
	docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) up builder
release:
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) build
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) up agent
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) run --rm app manage.py collectstatic --noinput
	docker-compose -p $(REL_PROJECT) -f $(REL_COMPOSE_FILE) run --rm app manage.py migrate --noinput

clean:
	 docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) kill
	 docker-compose -p $(DEV_PROJECT) -f $(DEV_COMPOSE_FILE) rm -f 
	 docker-compose -p $(DEV_PROJECT) -f $(REL_COMPOSE_FILE) kill
	 docker-compose -p $(DEV_PROJECT) -f $(REL_COMPOSE_FILE) rm -f

