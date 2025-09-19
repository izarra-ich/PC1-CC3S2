# Proyecto 5: Analizador de logs de red con seguridad integrada
## Makefile
#### Creación del Makefile
Estando en nuestra carpeta de trabajo, ejecutamos el siguiente comando:
```
touch Makefile
```
Luego dentro de ella ponemos lo siguiente:
```
carpetas:
	mkdir -p src tests docs out dist systemd
```
Con el make instalado(sudo apt install make), ejecutamos el comando 
```
make carpetas
```
Esto generará las carpetas para el proyecto. La estructura del proyecto quedaría de la siguiente manera:
```
src/
tests/
docs/
out/
dist/
systemd/
Makefile
```
#### Implementacion de targets necesarios para el proyecto
- Creamos el target tools, para verfificar que las herramientas que se van a usar están disponibles
```
tools:
	command -v curl >/dev/null || (echo "Falta curl" && exit 1)
	command -v dig >/dev/null || (echo "Falta dig" && exit 1)
	command -v bats >/dev/null || (echo "Falta bats" && exit 1)
	echo "Todas las herramientas requeridas están disponibles."
```
En caso falte alguno se usa el comando:
```
sudo apt install "Nombre de la Herramienta"
```
#### Archivo de Prueba con Bats para Tools
Se creará en la carpeta tests, el archivo makefile_tests.bats y se escribe lo siguiente:
```
#!/usr/bin/env bats

@test "tools: Verifica que las herramientas requeridas estén disponibles" {
  run make tools
  [ "$status" -eq 0 ]
  [[ "$output" == *"Todas las herramientas requeridas están disponibles."* ]]
}
```
- #!/usr/bin/env bats indica que el archivo se ejecuta con bats.
- @test " " Define una prueba con una descripción.
- [ "$status" -eq 0 ] Verifica que el código de salida fue 0.
- [[ "$output" == *" "* ]] Verifica que la salida incluya el texto esperado.

Luego le damos permisos de ejecución con el comando:
```
chmod +x tests/makefile_tests.bats
```
Para después correr el programa con:
```
bats tests/makefile_tests.bats
```
#### Crear target build en el Makefile
Se añade ahora al makefile lo siguiente:
```
build:
	@echo "Preparando entorno de ejecución..."
	@touch out/http.log
	@touch out/dns.log
```
- @echo Muestra el mensaje
- @touch crea el archivo
Ejecutamos make build, para la creación de los archivos http.log y dns.log en la carpeta out/.
#### Crear target run en el Makefile
Antes se creará archivos de simulacion (http y dns), ya que serán creados por los otros alumnos.
- http:
```
echo '#!/bin/bash
echo "Simulación de chequeo HTTP"
exit 0' > src/http_tls_checker.sh
chmod +x src/http_tls_checker.sh
```
- dns:
```
echo '#!/bin/bash
echo "Simulación de chequeo DNS"
exit 0' > src/dns_parser.sh
chmod +x src/dns_parser.sh
```
Tanto para http y dns se puede ejecutar los comando en bloque para la creación de los scripts de simulación.

Verificamos que las pruebas funcionen:
```
bash src/http_tls_checker.sh
bash src/dns_parser.sh
```
Ahora si en el Makefile añadimos el target run:
```
run:
	@echo "Ejecutando scripts principales..."
	@bash src/http_tls_checker.sh > out/http.log
	@bash src/dns_parser.sh > out/dns.log
```
- bash src/http_tlschecker.sh ejecuta el script simulado (Se encargará el alumno1)
- bash src/dns_parser.sh ejecuta el script simulado (alumno2)
- '>' guarda el resultado en el archivo dado.
#### Archivo de Prueba  con Bats para Run
Se añadio al archivo makefile_tests.bats:
```
@test "run: Ejecuta scripts y genera archivos en out/" {
  run make run
  [ "$status" -eq 0 ]
  [ -f "out/http.log" ]
  [ -f "out/dns.log" ]
  grep -q "Simulación de chequeo HTTP" out/http.log
  grep -q "Simulación de chequeo DNS" out/dns.log
}
```
- run make run, ejecuta el target run y guarda su salida
- [ "$status" -eq 0 ], verifica que el comando no fallo
- [ -f "archivo" ], verifica que los archivos existen
- greep -q "texto" archivo, verifica que el archivo contiene ese text
Para la ejecución usamos el comando:
```
bats tests/makefile_tests.bats
```
#### Crear target pack en el Makefile
Se añade al Makefile:
```
pack:
	@echo "Empaquetando proyecto en dist/"
	@tar -czf dist/proyecto5.tar.gz src/ out/
```
#### Crear target clean en el Makefile
Se añade el target clean en el makefile:
```
clean:
	@echo "Limpiando archivos generados..."
	@rm -f out/*.log
	@rm -f dist/*.tar.gz
```
- rm -f out/*.log, borra todos los archivos .log en la carpeta out/
- rm -f dist/*.tar.gz, borra el archivo .tar.gz que generaste en pack