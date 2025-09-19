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
#### Archivo de Prueba
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
