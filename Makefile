# Variables de entorno
PORT ?= 8080
RELEASE ?= v0
APP_NAME ?= flask-app
MESSAGE ?= Hola desde Makefile

VENV := venv
VENV_PROMPT := venv
VENV_BIN := $(VENV)/bin
PY_BOOT := $(shell if command -v py >/dev/null 2>&1; then echo "py -3"; elif command -v python3 >/dev/null 2>&1; then echo "python3"; else echo "python"; fi)
PY  := $(VENV_BIN)/python
PIP := $(PY) -m pip

carpetas:
	@mkdir -p src tests docs out dist systemd
	@echo "Carpetas creadas - src tests docs out dist systemd"

tools:
	@command -v curl >/dev/null || (echo "Falta curl" && exit 1)
	@command -v dig >/dev/null || (echo "Falta dig" && exit 1)
	@command -v bats >/dev/null || (echo "Falta bats" && exit 1)
	@echo "Todas las herramientas están disponibles"

build:
	@echo "Preparando entorno de ejecución..."
	@touch out/http.log
	@touch out/dns.log

# Target para crear venv e instalar Flask
prepare: $(VENV)
	@echo "Actualizando pip e instalando Flask..."
	@$(PIP) install --upgrade pip
	@$(PIP) install flask
	@mkdir -p out dist

# Crear entorno virtual con prompt 'venv'
$(VENV):
	@echo "Creando venv con: $(PY_BOOT) -m venv --prompt $(VENV_PROMPT) $(VENV)"
	@$(PY_BOOT) -m venv --prompt "$(VENV_PROMPT)" $(VENV)

# Ejecutar app Flask en segundo plano
run:
	@echo "Iniciando la aplicación Flask..."
	@PORT=$(PORT) APP_NAME=$(APP_NAME) MESSAGE="$(MESSAGE)" RELEASE=$(RELEASE) \
		$(PY) src/app.py > out/app_logs.txt 2>&1 & \
		echo $$! > out/app.pid; \
		echo "PID guardado en out/app.pid"
	@sleep 2
	@echo "Probando GET, POST, PUT y DELETE en http://127.0.0.1:$(PORT) ..." > out/http.log
	@curl -s -X GET http://127.0.0.1:$(PORT)/ >> out/http.log
	@curl -s -X POST http://127.0.0.1:$(PORT)/ >> out/http.log
	@curl -s -X PUT http://127.0.0.1:$(PORT)/ >> out/http.log
	@curl -s -X DELETE http://127.0.0.1:$(PORT)/ >> out/http.log
	@echo "Respuestas guardadas en out/http.log"

# Detener la app Flask si está en ejecución
stop:
	@echo "Deteniendo app Flask ejecutándose en puerto $(PORT)..."
	@if [ -f out/app.pid ]; then \
		PID=$$(cat out/app.pid); \
		echo "Deteniendo la app (PID=$$PID)..."; \
		kill $$PID && rm -f out/app.pid; \
	else \
		echo "No se encontró PID. ¿La app está corriendo?"; \
	fi

pack:
	@echo "Empaquetando proyecto en dist/"
	@tar -czf dist/proyecto5.tar.gz src/ out/

clean:
	@echo "Limpiando archivos generados..."
	@rm -f out/*.log out/app.pid
	@rm -f dist/*.tar.gz
	@rm -rf venv

.PHONY: clean build run tools pack carpetas prepare stop