#讀取.env
include ./.env
export $(shell sed 's/=.*//' ./.env)

COMPOSE=docker-compose
SERVICES=nginx

.PHONY: up, init, down

#
sh:
	$(COMPOSE) exec $(SERVICES) sh

#測試服務
dev:
	$(COMPOSE) up $(SERVICES)

#啟動服務
up:
	$(COMPOSE) up -d $(SERVICES)

#列出容器列表
ps:
	$(COMPOSE) ps

#重啟服務
restart:
	$(COMPOSE) restart

#初始化
init:
	$(COMPOSE) build --force-rm --no-cache
	$(MAKE) up

#關閉所有服務
down:
	$(COMPOSE) down
