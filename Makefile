.DEFAULT_GOAL := help

.PHONY: help
help:
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ golang
build: ## bin以下にbuildします
	GOBIN=$(CURDIR)/bin go install ./cmd/...
start: ## serverをstartします
	go run cmd/*.go start
.PHONY: vendor
vendor: ## 依存関係を更新します
	go mod vendor && go mod tidy
##@ docker
build-image: ## api-abilitysheetのimageを作成します
	@docker build -t api-abilitysheet:latest .
start-image: build-image ## api-abilitysheetのimageを使ってサーバを起動します
	@docker run -p 8080:8080 -e DB_URL=${DB_URL_FOR_DOCKER} --rm -it api-abilitysheet:latest
