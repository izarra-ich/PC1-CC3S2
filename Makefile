# === Makefile inicial Sprint 1 ===
# Variables
BATS ?= bats
OUTDIR = out
DISTDIR = dist

.PHONY: tools build run test pack clean help

# Verifica que las herramientas mínimas estén instaladas
tools:
	@command -v dig >/dev/null || (echo "ERROR: falta dig" && exit 1)
	@command -v $(BATS) >/dev/null || (echo "ERROR: falta bats" && exit 1)
	@command -v awk >/dev/null || (echo "ERROR: falta awk" && exit 1)
	@echo "✔ Todas las herramientas requeridas están disponibles."

# Construcción inicial (puede preparar directorios)
build:
	mkdir -p $(OUTDIR) $(DISTDIR)
	@echo "✔ Build listo"

# Ejecuta el flujo principal (ejemplo: DNS y logs)
run: build
	./src/dns_check.sh example.com
	./src/parse_logs.sh

# Ejecuta pruebas Bats
test: build
	$(BATS) tests/*.bats

# Empaquetar en dist/ con nombre según fecha
pack: build
	tar -czf $(DISTDIR)/package_`date +%Y%m%d`.tar.gz src tests Makefile
	@echo "✔ Paquete generado en dist/"

# Limpieza
clean:
	rm -rf $(OUTDIR)/* $(DISTDIR)/*
	@echo "✔ Limpieza completada"

# Ayuda
help:
	@echo "Targets disponibles:"
	@echo "  tools   -> Verificar utilidades instaladas"
	@echo "  build   -> Preparar directorios de salida"
	@echo "  run     -> Ejecutar scripts principales"
	@echo "  test    -> Ejecutar pruebas con Bats"
	@echo "  pack    -> Generar paquete reproducible"
	@echo "  clean   -> Limpiar directorios out/ y dist/"
