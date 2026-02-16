# Fetch available models from proxy
.PHONY: models-list
models-list:
	@bash -c 'set -a; . .env; set +a; curl -s -X GET "$$LITELLM_PROXY_URL/v1/models" -H "Authorization: Bearer $$LITELLM_PROXY_API_KEY" | jq'

# .PHONY: proxy-redeploy
# proxy-redeploy:
# 	@if [ -z "$$CONFIG" ]; then \
# 	  echo "Usage: make proxy-redeploy CONFIG=path/to/config.yaml"; \
# 	  exit 1; \
# 	fi; \
# 	cp "$$CONFIG" config.yaml; \
# 	docker compose -f docker/docker-compose.yml stop litellm; \
# 	docker compose -f docker/docker-compose.yml rm -f litellm; \
# 	docker compose -f docker/docker-compose.yml up -d --force-recreate --no-deps litellm; \
# 	echo "Proxy redeployed with config file: $$CONFIG"

# Restart litellm proxy
.PHONY: restart
restart: 
	docker compose -f docker/docker-compose.yml restart litellm

# Test Gemini model via proxy
.PHONY: test-gemini
test-gemini:
	@bash -c 'set -a; . .env; set +a; curl -s -X POST "$$LITELLM_PROXY_URL/v1/completions" -H "Authorization: Bearer $$LITELLM_PROXY_API_KEY" -H "Content-Type: application/json" -d "{\"model\": \"gemini-pro\", \"prompt\": \"Hello, who are you?\", \"max_tokens\": 64}" | jq'

# Start Ollama server locally
.PHONY: ollama-up
ollama-up:
	ollama serve &

# Run litellm-proxy CLI with .env loaded
.PHONY: proxy
proxy:
	@set -a; . .env; set +a; litellm-proxy $(ARGS)

# Show help for Makefile commands
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  docker-up      Start all services with Docker Compose"
	@echo "  docker-down    Stop and remove all services and volumes"
	@echo "  docker-logs    Show logs for all services"
	@echo "  help           Show this help message"

.PHONY: gemini-set-key
gemini-set-key:
	@echo "Paste your Gemini API key (starts with 'AIza' or similar):" && \
	read token && \
	sed -i.bak '/^GEMINI_API_KEY=/d' .env && \
	echo "GEMINI_API_KEY=\"$$token\"" >> .env && \
	echo "Gemini API key set in .env. Restarting the proxy..." && \
	docker compose -f docker/docker-compose.yml restart litellm && \
	echo "Proxy restarted. Gemini key is now active."

.PHONY: copilot-refresh-token
copilot-refresh-token:
	@echo "Paste your GitHub Copilot token (starts with 'ghu_'):" && \
	read token && \
	sed -i.bak '/^OPENAI_API_KEY=/d' .env && \
	echo "OPENAI_API_KEY=\"$$token\"" >> .env && \
	echo "Token set in .env. Restarting the proxy..." && \
	docker compose -f docker/docker-compose.yml restart litellm && \
	echo "Proxy restarted. Copilot token is now active."

.PHONY: docker-up
docker-up: 
	docker compose -f docker/docker-compose.yml up -d

.PHONY: docker-down
docker-down:
	docker compose -f docker/docker-compose.yml down -v --remove-orphans

.PHONY: docker-logs
docker-logs:
	docker compose -f docker/docker-compose.yml logs -f

# Test Ollama model via proxy
.PHONY: test-ollama
test-ollama: 
	@bash -c 'set -a; . .env; set +a; curl -s -X POST "$$LITELLM_PROXY_URL/v1/completions" -H "Authorization: Bearer $$LITELLM_PROXY_API_KEY" -H "Content-Type: application/json" -d "{\"model\": \"ollama/llama2\", \"prompt\": \"Hello, who are you?\", \"max_tokens\": 20}" | jq'

# Test GitHub Copilot model via proxy
.PHONY: test-copilot
test-copilot:
	@bash -c 'set -a; . .env; set +a; curl -s -X POST "$$LITELLM_PROXY_URL/v1/completions" -H "Authorization: Bearer $$LITELLM_PROXY_API_KEY" -H "Content-Type: application/json" -d "{\"model\": \"github/copilot\", \"prompt\": \"Write a Python function to add two numbers.\", \"max_tokens\": 64}" | jq'
