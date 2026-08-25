# Makefile для Flask + Jinja2 проекта
# ---------------------------------------------------
# Targets:
#   venv           — создать виртуальное окружение
#   install        — установить зависимости из requirements.txt
#   run            — запустить dev-сервер на порту 5006
#   test           — запустить все тесты
#   clean          — удалить окружение и кэш
#   docker-dev     — запустить всё в Docker (разработка)
#   docker-prod    — запустить всё в Docker (продакшн)
#   docker-stop    — остановить Docker контейнеры
#   docker-clean   — очистить только данные и контейнеры этого проекта
#   migrate-reset  — полный сброс БД (локально или в Docker)
# ---------------------------------------------------

# ========== [ Общие переменные ] ==========
SHELL := /bin/bash
VENV := .venv
PY := $(VENV)/bin/python
PIP := $(VENV)/bin/pip
FLASK := $(VENV)/bin/flask
REQ := requirements.txt
DEFAULT_PORT := 5006
DB_ENV ?= local
LOCAL_DATABASE_URL ?= sqlite:///app.db
PG_DB ?= jinja_app
PG_USER ?= postgres
PG_HOST ?= localhost

.PHONY: venv install run dev setup help test test-unit test-integration clean freeze \
        docker-dev docker-prod docker-stop docker-clean docker-db-clean docker-logs docker-shell docker-db-shell \
        init-db seed-db migrate-init migrate migrate-downgrade drop-db-local recreate-db-local migrate-reset kill-port kill-all-ports

# ========== [ HELP ] ==========
help: ## Показать справку
	@echo "\n\033[1;34mДоступные команды:\033[0m"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'
	@echo "\n\033[1;33mПримеры:\033[0m"
	@echo "  make migrate-reset DB_ENV=local   # полный сброс БД локально"
	@echo "  make migrate-reset DB_ENV=docker  # полный сброс БД в Docker"

# ========== [ VENV & DEPENDENCIES ] ==========
$(PIP):
	@echo "⚙️  Создаём виртуальное окружение .venv..."
	@python3 -m venv $(VENV)
	@echo "✅ Окружение готово."

venv: $(PIP) ## Создать виртуальное окружение

install: venv ## Создать окружение и установить зависимости
	@echo "📦 Устанавливаем зависимости из requirements.txt..."
	@$(PY) -m pip install --upgrade pip
	@$(PY) -m pip install -r $(REQ)
	@echo "✅ Зависимости установлены."

freeze: venv ## Заморозить зависимости
	@$(PY) -m pip freeze > $(REQ)
	@echo "✅ Зависимости заморожены в requirements.txt"

# ========== [ RUN & DEV ] ==========
run: ## Запустить приложение локально
	@echo "🔫 Очищаем порт $(DEFAULT_PORT)..."
	@lsof -ti:$(DEFAULT_PORT) | xargs kill -9 2>/dev/null || true
	@echo "✅ Порт $(DEFAULT_PORT) свободен."
	@echo "🚀 Запуск Flask на порту $(DEFAULT_PORT)..."
	@DATABASE_URL=$(LOCAL_DATABASE_URL) FLASK_APP=run.py FLASK_ENV=development FLASK_RUN_PORT=$(DEFAULT_PORT) $(FLASK) run
# 		@echo "# Экспортируем переменные окружения:"
# 	@echo "FLASK_APP=run.py \\"
# 	@echo "        FLASK_ENV=development \\"
# 	@echo "        FLASK_RUN_PORT=$(DEFAULT_PORT) \\"
# 	@echo "        .venv/bin/flask run"
# 	@FLASK_APP=run.py \
# 		FLASK_ENV=development \
# 		FLASK_RUN_PORT=$(DEFAULT_PORT) \
# 		.venv/bin/flask run

setup: install init-db seed-db ## Полная настройка проекта локально
	@echo "✅ Проект настроен локально."

dev: setup run ## Настройка и запуск для разработки локально
	@echo "✅ Локальная разработка запущена."

# ========== [ TESTS ] ==========
test: ## Запустить все тесты
	@echo "🧪 Запуск всех тестов..."
	@.venv/bin/python -m pytest tests/ -v
	@echo "✅ Все тесты завершены."

test-unit: ## Запустить unit тесты
	@echo "🧪 Запуск unit тестов..."
	@.venv/bin/python -m pytest tests/unit/ -v
	@echo "✅ Unit тесты завершены."

test-integration: ## Запустить integration тесты
	@echo "🧪 Запуск integration тестов..."
	@.venv/bin/python -m pytest tests/integration/ -v
	@echo "✅ Integration тесты завершены."

# ========== [ CLEAN ] ==========
clean: ## Очистить кэш Python
	@find . -type d -name "__pycache__" -exec rm -rf {} +
	@find . -type f -name "*.pyc" -delete
	@echo "✅ Кэш Python очищен."

kill-port: ## Убить процесс на порту $(DEFAULT_PORT)
	@lsof -ti:$(DEFAULT_PORT) | xargs kill -9 2>/dev/null || echo "Порт $(DEFAULT_PORT) уже свободен"
	@echo "✅ Порт $(DEFAULT_PORT) очищен."

kill-all-ports: ## Убить все процессы на портах 5000-5010
	@for port in {5000..5010}; do \
		lsof -ti:$$port | xargs kill -9 2>/dev/null || true; \
	done
	@echo "✅ Все порты 5000-5010 очищены."

# ========== [ DOCKER BLOCK ] ==========
# --- Docker: запуск, остановка, логи, shell ---
docker-dev: ## Запустить всё в Docker (разработка)
	@echo "🐳 Запускаем приложение в Docker (разработка)..."
	@docker-compose up --build -d
	@sleep 10
	@echo "✅ Приложение запущено на http://localhost:$(DEFAULT_PORT)"
	@echo "📊 База данных доступна на localhost:5432"
	@echo "🔍 Логи: docker-compose logs -f"

docker-prod: ## Запустить всё в Docker (продакшн)
	@echo "🐳 Запускаем приложение в Docker (продакшн)..."
	@FLASK_ENV=production docker-compose -f docker-compose.yml up --build -d
	@echo "✅ Приложение запущено в продакшн режиме"

docker-stop: ## Остановить Docker контейнеры
	@echo "🛑 Останавливаем Docker контейнеры..."
	@docker-compose down
	@echo "✅ Контейнеры остановлены"

docker-clean: ## Очистить только данные и контейнеры этого проекта (без глобального prune!)
	@echo "🧹 Очищаем только контейнеры и volume этого проекта..."
	@docker-compose down -v
	@echo "✅ Контейнеры и volume проекта удалены"

docker-db-clean: ## Удалить только volume базы данных проекта
	@echo "🧹 Удаляем volume postgres_data..."
	@docker-compose down
	@docker volume rm introductory-jinja_postgres_data || true
	@echo "✅ Volume базы данных удалён"

docker-logs: ## Показать логи Docker контейнеров
	@docker-compose logs -f

docker-shell: ## Войти в контейнер приложения
	@docker-compose exec web bash

docker-db-shell: ## Войти в контейнер базы данных
	@docker-compose exec db psql -U postgres -d jinja_app

# ========== [ DB MANAGEMENT BLOCK ] ==========
# --- Универсальные команды для локали и Docker ---
ifeq ($(DB_ENV),docker)
DB_EXEC = docker-compose exec web flask
DB_ENV_PREFIX =
else
DB_EXEC = $(FLASK)
DB_ENV_PREFIX = DATABASE_URL=$(LOCAL_DATABASE_URL)
endif

init-db: ## Инициализировать базу данных (локально или в Docker)
	@echo "Инициализация БД ($(DB_ENV))..."
	@$(DB_ENV_PREFIX) FLASK_APP=run.py $(DB_EXEC) init-db
	@echo "✅ База данных инициализирована."

seed-db: ## Заполнить базу данных тестовыми данными (локально или в Docker)
	@echo "Сидирование БД ($(DB_ENV))..."
	@$(DB_ENV_PREFIX) FLASK_APP=app.core:create_app $(DB_EXEC) seed-db
	@echo "✅ База данных заполнена тестовыми данными."

migrate-init: ## Инициализировать Flask-Migrate (локально или в Docker)
	@echo "Инициализация миграций ($(DB_ENV))..."
	@$(DB_ENV_PREFIX) FLASK_APP=app.core:create_app $(DB_EXEC) db init
	@echo "✅ Миграции инициализированы."

migrate-create: ## Создать новую миграцию (локально или в Docker)
	@echo "Создание миграции ($(DB_ENV))..."
	@$(DB_ENV_PREFIX) FLASK_APP=app.core:create_app $(DB_EXEC) db migrate -m "Auto migration"
	@echo "✅ Миграция создана."

migrate: ## Применить миграции (локально или в Docker)
	@echo "Применение миграций ($(DB_ENV))..."
	@$(DB_ENV_PREFIX) FLASK_APP=app.core:create_app $(DB_EXEC) db upgrade
	@echo "✅ Миграции применены."

migrate-downgrade: ## Откатить миграцию (локально или в Docker)
	@echo "Откат миграции ($(DB_ENV))..."
	@$(DB_ENV_PREFIX) FLASK_APP=app.core:create_app $(DB_EXEC) db downgrade prev
	@echo "✅ Миграция откатилась."

# --- Только для локальной среды ---
ifeq ($(DB_ENV),local)
drop-db-local: ## [LOCAL] Удалить базу данных PostgreSQL (jinja_app)
	@echo "Удаляем базу данных $(PG_DB)..."
	@PGPASSWORD=$(POSTGRES_PASSWORD) psql -U $(PG_USER) -h $(PG_HOST) -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$(PG_DB)';" || true
	@PGPASSWORD=$(POSTGRES_PASSWORD) psql -U $(PG_USER) -h $(PG_HOST) -d postgres -c "DROP DATABASE IF EXISTS $(PG_DB);"
	@echo "✅ База данных $(PG_DB) удалена."

recreate-db-local: drop-db-local ## [LOCAL] Пересоздать базу данных PostgreSQL (jinja_app)
	@echo "Создаём базу данных $(PG_DB)..."
	@PGPASSWORD=$(POSTGRES_PASSWORD) psql -U $(PG_USER) -h $(PG_HOST) -d postgres -c "CREATE DATABASE $(PG_DB) OWNER $(PG_USER);"
	@echo "✅ База данных $(PG_DB) создана."
endif

# --- Полный сброс БД ---# Обновлённый полный сброс БД -> make migrate-reset DB_ENV=docker
migrate-reset: ## Полный сброс: удалить БД, применить миграции, накатить сиды (локально или в Docker)
	@echo "🔄 Полный сброс базы данных ($(DB_ENV))..."
ifeq ($(DB_ENV),local)
	$(MAKE) recreate-db-local
endif
ifeq ($(DB_ENV),docker)
	@echo "🧹 Очищаем volume базы данных Docker..."
	@docker-compose down -v
	@docker-compose up -d db
	@sleep 10
	@echo "✅ Volume базы данных Docker пересоздан."
endif
	@$(DB_ENV_PREFIX) FLASK_APP=app.core:create_app $(DB_EXEC) db upgrade
	@$(DB_ENV_PREFIX) FLASK_APP=app.core:create_app $(DB_EXEC) seed-db
	@echo "✅ База данных сброшена и заполнена тестовыми данными."

# ========== [ END ] ==========

# Для инициализации и наполнения БД
init-db-old:
	FLASK_APP=run.py flask init-db
	FLASK_APP=run.py flask seed-db

# Команды для очистки и архивирования проекта!!!!!!!!!!!!!!!!!!
clean-project: ## Очистить проект от временных файлов
	@echo "🧹 Очищаем проект от временных файлов..."
	@python clean_project.py

clean-all: clean clean-project ## Полная очистка (кэш + временные файлы)
	@echo "✅ Полная очистка завершена"

archive: clean-project ## Создать архив проекта
	@echo "📦 Создаём архив проекта..."
	@PROJECT_NAME=$$(basename $$(pwd)) && \
	ARCHIVE_NAME="$${PROJECT_NAME}_$(shell date +%Y%m%d_%H%M%S).tar.gz" && \
	tar --exclude='.git' --exclude='.venv' --exclude='venv' --exclude='node_modules' \
		--exclude='__pycache__' --exclude='*.pyc' --exclude='.pytest_cache' \
		--exclude='.coverage' --exclude='htmlcov' --exclude='.tox' \
		--exclude='.vscode' --exclude='.idea' --exclude='.DS_Store' \
		--exclude='*.log' --exclude='instance' --exclude='*.db' \
		--exclude='*.sqlite' --exclude='*.sqlite3' \
		-czf "$$ARCHIVE_NAME" . && \
	echo "✅ Архив создан: $$ARCHIVE_NAME" && \
	echo "📊 Размер архива: $$(du -h "$$ARCHIVE_NAME" | cut -f1)"

archive-clean: clean-all archive ## Очистить и создать архив

prepare-release: clean-project ## Подготовить проект к релизу
	@echo "🚀 Подготовка проекта к релизу..."
	@echo "✅ Проект готов к архивированию"
	@echo "📋 Следующие шаги:"
	@echo "   1. Проверьте код: make lint"
	@echo "   2. Запустите тесты: make test"
	@echo "   3. Создайте архив: make archive"

lint: ## Проверить код линтерами
	@echo "🔍 Проверяем код..."
	@flake8
	@echo "✅ Код проверен"

format: ## Отформатировать код
	@echo "🎨 Форматируем код..."
	@black .
	@isort .
	@echo "✅ Код отформатирован"

lint-fix: format ## Исправить проблемы с кодом
	@echo "🔧 Исправляем проблемы..."
	@autopep8 --in-place --recursive --aggressive --aggressive .
	@echo "✅ Проблемы исправлены"
# ---------------------------

protected-build: ## Собрать защищённую версию проекта с таймер-бомбой (7 дней)
	@echo "🛡️  Создаём защищённую версию проекта..."
	@rm -rf protected_build && mkdir protected_build
	@rsync -a --exclude='.git' --exclude='.venv' --exclude='__pycache__' --exclude='*.pyc' --exclude='*.db' --exclude='*.sqlite' --exclude='*.sqlite3' ./ protected_build/
	@cp app/core/self_destruct.py protected_build/app/core/self_destruct.py || true
	@echo "from .self_destruct import check_payment_guard; check_payment_guard()" | cat - protected_build/app/core/__init__.py > protected_build/app/core/__init__.py.tmp && mv protected_build/app/core/__init__.py.tmp protected_build/app/core/__init__.py
	@echo "✅ Защищённая версия собрана в ./protected_build"
