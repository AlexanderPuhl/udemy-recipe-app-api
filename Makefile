.PHONY: help test test-coverage migrate makemigrations shell build up down logs clean

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

test: ## Run Django tests
	docker-compose run --rm app sh -c 'python manage.py test'

test-coverage: ## Run tests with coverage report
	docker-compose run --rm app sh -c 'coverage run --source="." manage.py test && coverage report'

migrate: ## Run database migrations
	docker-compose run --rm app sh -c 'python manage.py migrate'

makemigrations: ## Create new migrations
	docker-compose run --rm app sh -c 'python manage.py makemigrations'

shell: ## Open Django shell
	docker-compose run --rm app sh -c 'python manage.py shell'

build: ## Build Docker containers
	docker-compose build

up: ## Start all services
	docker-compose up -d

down: ## Stop all services
	docker-compose down

logs: ## Show logs
	docker-compose logs -f

clean: ## Clean up Docker resources
	docker-compose down -v
	docker system prune -f

install-dev: ## Install development dependencies
	docker-compose run --rm app sh -c 'pip install -r requirements.dev.txt'

check: ## Run code quality checks
	docker-compose run --rm app sh -c 'flake8 . && black --check . && isort --check-only .'
