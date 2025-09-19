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