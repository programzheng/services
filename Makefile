#讀取.env
include ./.env
export $(shell sed 's/=.*//' ./.env)

#當前年-月-日
DATE=$(shell date +"%F")
COMPOSE=docker-compose
SERVICES=portainer nginx mysql postgres redis

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
	$(COMPOSE) restart $(service)

#初始化
init:
	$(COMPOSE) build --force-rm --no-cache
	$(MAKE) up

#重新啟動、建立單一服務(重新取得docker-composer.yml設定)
reup:
	$(COMPOSE) up -d --force-recreate --no-deps --build $(service)

#關閉所有服務
down:
	$(COMPOSE) down

cert-bot:
	docker run --rm -v /nginx/letsencrypt:/etc/letsencrypt -ti certbot/certbot certonly --manual --email $(CERTBOT_EMAIL) --domains=$(domain)

#備份mysql all database
mysql-backup:
	$(COMPOSE) up -d mysql
	$(MAKE) check-data-directory-mysql-backup
	cp -R -f $(DATA_PATH_HOST)/mysql $(DATA_PATH_HOST)/mysql-backup/$(DATE)
	# remove 3 days ago backup directory
	rm -r $(DATA_PATH_HOST)/mysql-backup/$(shell date --date="3 days ago" +"%F")

#檢查資料夾並建立
check-data-directory-%:
	if test -d $(DATA_PATH_HOST)/$*; \
	then echo $* is exists; exit 0; \
	else mkdir $(DATA_PATH_HOST)/$*; \
	fi