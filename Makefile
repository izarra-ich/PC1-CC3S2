# venv: 'bdd' (prompt (bdd))
.SHELL := /bin/bash
.DEFAULT_GOAL := help

# venv con nombre/prompt 'bdd'
VENV := bdd
VENV_PROMPT := bdd

# Variables (12-Factor)
PORT ?= 8080
RELEASE ?= v0
APP_NAME ?= miapp
MESSAGE ?= Hola

OUT := out
DIST := dist

VENV_BIN := $(VENV)/bin

# Intérprete para crear la venv (py -3 | python3 | python)
PY_BOOT := $(shell if command -v py >/dev/null 2>&1; then echo "py -3"; \
	elif command -v python3 >/dev/null 2>&1; then echo "python3"; \
	else echo "python"; fi)

PY  := $(VENV_BIN)/python
PIP := $(PY) -m pip   

APP_DIR := $(shell pwd)

# Herramientas (pueden faltar en Windows)
CURL    := $(shell command -v curl 2>/dev/null)
DIG     := $(shell command -v dig 2>/dev/null)
SS      := $(shell command -v ss 2>/dev/null)
BATS		:= $(shell command -v bats 2>/dev/null)
NC      := $(shell command -v nc 2>/dev/null)
GREP    := $(shell command -v grep 2>/dev/null)
SED     := $(shell command -v sed 2>/dev/null)
AWL 		:= $(shell command -v awk 2>/dev/null)

# Ayuda / Debug
.PHONY: help
help: ## Muestra los targets disponibles
	@echo "Make targets:"
	@grep -E '^[a-zA-Z0-9_\-]+:.*?##' $(MAKEFILE_LIST) | \
		awk 'BEGIN{FS=":.*?##"}{printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2}'

tools: ## Verifica que las herramientas necesarias estén instaladas
	@echo "Verificando herramientas necesarias..."
	@missing=0; for cmd in curl dig ss nc sed awk grep bats; do \
	  command -v $$cmd >/dev/null || { echo "Falta $$cmd"; missing=1; }; \
	done; [ $$missing -eq 0 ] || { echo "Instala las utilidades faltantes"; :; }

# Preparación para ejecución de App
.PHONY: prepare
prepare: $(VENV) ## Crear venv 'bdd' e instalar dependencias para ejecutar la app Flask
	@echo "Actualizando pip e instalando Flask..."
	@$(PIP) --version
	@$(PIP) install --upgrade pip
	@$(PIP) install flask
	@echo "Creando directorios $(OUT) y $(DIST)..."
	@mkdir -p $(OUT) $(DIST)

# Crear venv con prompt 'bdd'
$(VENV):
	@echo "Creando venv con: $(PY_BOOT) -m venv --prompt $(VENV_PROMPT) $(VENV)"
	@$(PY_BOOT) -m venv --prompt "$(VENV_PROMPT)" $(VENV)

.PHONY: run
run: ## Ejecutar app Flask en segundo plano.
	@echo "Iniciando la aplicación en http://127.0.0.1:$(PORT) ..."
	@PORT=$(PORT) MESSAGE="$(MESSAGE)" RELEASE="$(RELEASE)" \
		$(PY) src/app.py > $(OUT)/app_logs.txt 2>&1 & \
	echo $$! > $(OUT)/app.pid; \
	echo "PID guardado en $(OUT)/app.pid"

.PHONY: stop
stop: ## Detener app Flask
	@echo "Deteniendo app Flask ejecutandose en puerto $(PORT)..."
	@if [ -f $(OUT)/app.pid ]; then \
	  PID=$$(cat $(OUT)/app.pid); \
	  echo "Deteniendo la app (PID=$$PID)..."; \
	  kill $$PID && rm -f $(OUT)/app.pid; \
	fi

.PHONY: cleanup
cleanup: ## Elimina venv y directorios generados
	@echo "Eliminando directorios $(OUT) y $(DIST)..."
	@rm -rf $(OUT) $(DIST)
	@echo "Eliminando venv $(VENV)..."
	@rm -rf $(VENV)
