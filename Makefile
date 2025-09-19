carpetas:
	@mkdir -p src tests docs out dist systemd
	echo "Carpetas creadas - src tests docs out dist systemd"
tools:
	@command -v curl >/dev/null || (echo "Falta curl" && exit 1)
	@command -v dig >/dev/null || (echo "Falta dig" && exit 1)
	@command -v bats >/dev/null || (echo "Falta bats" && exit 1)
	@echo "Todas las herramientas están disponibles"
build:
	@echo "Preparando entorno de ejecución..."
	@touch out/http.log
	@touch out/dns.log
run:
	@echo "Ejecutando scripts principales..."
	@bash src/http_tls_checker.sh > out/http.log
	@bash src/dns_parser.sh > out/dns.log
pack:
	@echo "Empaquetando proyecto en dist/"
	@tar -czf dist/proyecto5.tar.gz src/ out/
clean:
	@echo "Limpiando archivos generados..."
	@rm -f out/*.log
	@rm -f dist/*.tar.gz

.PHONY: clean build run tools pack carpetas test