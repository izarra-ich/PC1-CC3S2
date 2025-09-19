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