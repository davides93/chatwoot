# Variables
APP_NAME := chatwoot
RAILS_ENV ?= development

# Targets
setup:
	gem install bundler
	bundle install
	pnpm install

db_create:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:create

db_migrate:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:migrate

db_seed:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:seed

db_reset:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:reset

db:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails db:chatwoot_prepare

console:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails console

server:
	RAILS_ENV=$(RAILS_ENV) bundle exec rails server -b 0.0.0.0 -p 3000

burn:
	bundle && pnpm install

run:
	@if [ -f ./.overmind.sock ]; then \
		echo "Overmind is already running. Use 'make force_run' to start a new instance."; \
	else \
		overmind start -f Procfile.dev; \
	fi

force_run:
	@echo "Cleaning up Overmind processes..."
	@lsof -ti:3036 2>/dev/null | xargs kill -9 2>/dev/null || true
	@lsof -ti:3000 2>/dev/null | xargs kill -9 2>/dev/null || true
	@rm -f ./.overmind.sock
	@rm -f tmp/pids/*.pid
	@echo "Cleanup complete"
	overmind start -f Procfile.dev

force_run_tunnel:
	lsof -ti:3000 | xargs kill -9 2>/dev/null || true
	rm -f ./.overmind.sock
	rm -f tmp/pids/*.pid
	overmind start -f Procfile.tunnel

debug:
	overmind connect backend

debug_worker:
	overmind connect worker

docker:
	docker build -t $(APP_NAME) -f ./docker/Dockerfile .

# Full local preview stack (production-like build, own postgres/redis/mailhog).
# First run: cp .env.preview.example .env.preview && set SECRET_KEY_BASE, then `make preview_setup`.
preview_setup:
	docker compose -f docker-compose.preview.yaml build
	docker compose -f docker-compose.preview.yaml up -d postgres redis mailhog
	docker compose -f docker-compose.preview.yaml run --rm rails bundle exec rails db:chatwoot_prepare
	docker compose -f docker-compose.preview.yaml run --rm rails bundle exec rails preview:seed_admin

preview:
	docker compose -f docker-compose.preview.yaml up -d

preview_down:
	docker compose -f docker-compose.preview.yaml down

# Hot-reload preview stack (mirrors docker-compose.yaml, isolated ports/volumes).
preview_dev_setup:
	docker compose -f docker-compose.preview.dev.yaml build base
	docker compose -f docker-compose.preview.dev.yaml up -d postgres redis mailhog
	docker compose -f docker-compose.preview.dev.yaml run --rm rails bundle exec rails db:chatwoot_prepare
	docker compose -f docker-compose.preview.dev.yaml run --rm rails bundle exec rails preview:seed_admin

preview_dev:
	docker compose -f docker-compose.preview.dev.yaml up

preview_dev_down:
	docker compose -f docker-compose.preview.dev.yaml down

.PHONY: setup db_create db_migrate db_seed db_reset db console server burn docker run force_run force_run_tunnel debug debug_worker \
	preview_setup preview preview_down preview_dev_setup preview_dev preview_dev_down
