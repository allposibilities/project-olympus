# Día 16 — Fundamentos de Docker

## Objetivo
Ejecutar una página de Olympus en un contenedor y comprender
imágenes, contenedores, publicación de puertos, logs y ciclo de vida.

## Entorno
- Host Docker: olympus-node01, ambiente de desarrollo.
- Ubuntu 22.04.5 LTS; 2 CPU disponibles y aproximadamente 2 GiB de RAM.
- IP verificada durante la práctica: 192.168.81.136, mediante DHCP.
- Docker Engine y CLI: 29.9.1.
- Volumen lógico raíz ampliado de 10 a 16 GiB.
- Espacio sin asignar restante en ubuntu-vg: aproximadamente 2.22 GiB.

## Decisión de arquitectura
Docker Engine se ejecuta en la VM de desarrollo.
WSL permanece como estación de ingeniería y control de Ansible.
Los contenedores comparten el kernel y los recursos de la VM.

## Servicios
- Nginx instalado con Ansible: puerto 80 de la VM.
- Contenedor olympus-web: imagen nginx:stable.
- Publicación: 127.0.0.1:8080 de la VM hacia el puerto 80 del contenedor.
- El servicio del contenedor se consulta localmente desde la VM.

## Validaciones realizadas
- hello-world ejecutó su programa y terminó correctamente: Exited (0).
- docker start reutilizó el mismo contenedor y conservó su ID.
- Nginx en contenedor respondió HTTP 200.
- Una petición a localhost:8080 desde WSL falló:
  localhost de WSL no es localhost de la VM.
- Los logs registraron las peticiones HEAD con código 200.
- Al detener olympus-web, el puerto 8080 dejó de responder.
- Nginx de la VM continuó respondiendo en el puerto 80.
- Al iniciar nuevamente olympus-web, el servicio se recuperó.
- curl devolvió el HTML personalizado de Project Olympus.

## Archivo fuente y despliegue
Fuente: docker/nginx/index.html.

Se transfirió el HTML desde WSL a la VM mediante scp.
Se copió al contenedor mediante docker cp, en:
 /usr/share/nginx/html/index.html

## Conceptos aprendidos
- Una imagen es la plantilla para crear contenedores.
- docker run crea e inicia un contenedor nuevo.
- docker start inicia un contenedor existente.
- El contenedor permanece activo mientras se ejecuta su proceso principal.
- La opción -d ejecuta en segundo plano; no mantiene vivo el proceso.
- Detener un contenedor no lo elimina ni elimina su imagen.
- Los puertos del host y del contenedor pertenecen a entornos de red distintos.
- docker logs permite revisar la salida registrada del contenedor.

## Limitaciones actuales
- La página contiene valores estáticos.
- La copia manual modifica el contenedor, no la imagen nginx:stable.
- El HTML sobrevive a stop/start del mismo contenedor.
- Si eliminamos el contenedor, esa copia se pierde.
- La etiqueta stable puede apuntar a otra imagen en el futuro.
- Todavía no se configuró una política de reinicio automático.

## Próximo paso
Aprender Dockerfile y construir una imagen propia que incluya
la página de Olympus para reproducir el despliegue# Día 16 — Fundamentos de Docker

## Objetivo
Ejecutar una página de Olympus en un contenedor y comprender
imágenes, contenedores, publicación de puertos, logs y ciclo de vida.

## Entorno
- Host Docker: olympus-node01, ambiente de desarrollo.
- Ubuntu 22.04.5 LTS; 2 CPU disponibles y aproximadamente 2 GiB de RAM.
- IP verificada durante la práctica: 192.168.81.136, mediante DHCP.
- Docker Engine y CLI: 29.9.1.
- Volumen lógico raíz ampliado de 10 a 16 GiB.
- Espacio sin asignar restante en ubuntu-vg: aproximadamente 2.22 GiB.

## Decisión de arquitectura
Docker Engine se ejecuta en la VM de desarrollo.
WSL permanece como estación de ingeniería y control de Ansible.
Los contenedores comparten el kernel y los recursos de la VM.

## Servicios
- Nginx instalado con Ansible: puerto 80 de la VM.
- Contenedor olympus-web: imagen nginx:stable.
- Publicación: 127.0.0.1:8080 de la VM hacia el puerto 80 del contenedor.
- El servicio del contenedor se consulta localmente desde la VM.

## Validaciones realizadas
- hello-world ejecutó su programa y terminó correctamente: Exited (0).
- docker start reutilizó el mismo contenedor y conservó su ID.
- Nginx en contenedor respondió HTTP 200.
- Una petición a localhost:8080 desde WSL falló:
  localhost de WSL no es localhost de la VM.
- Los logs registraron las peticiones HEAD con código 200.
- Al detener olympus-web, el puerto 8080 dejó de responder.
- Nginx de la VM continuó respondiendo en el puerto 80.
- Al iniciar nuevamente olympus-web, el servicio se recuperó.
- curl devolvió el HTML personalizado de Project Olympus.

## Archivo fuente y despliegue
Fuente: docker/nginx/index.html.

Se transfirió el HTML desde WSL a la VM mediante scp.
Se copió al contenedor mediante docker cp, en:
 /usr/share/nginx/html/index.html

## Conceptos aprendidos
- Una imagen es la plantilla para crear contenedores.
- docker run crea e inicia un contenedor nuevo.
- docker start inicia un contenedor existente.
- El contenedor permanece activo mientras se ejecuta su proceso principal.
- La opción -d ejecuta en segundo plano; no mantiene vivo el proceso.
- Detener un contenedor no lo elimina ni elimina su imagen.
- Los puertos del host y del contenedor pertenecen a entornos de red distintos.
- docker logs permite revisar la salida registrada del contenedor.

## Limitaciones actuales
- La página contiene valores estáticos.
- La copia manual modifica el contenedor, no la imagen nginx:stable.
- El HTML sobrevive a stop/start del mismo contenedor.
- Si eliminamos el contenedor, esa copia se pierde.
- La etiqueta stable puede apuntar a otra imagen en el futuro.
- Todavía no se configuró una política de reinicio automático.

## Próximo paso
Aprender Dockerfile y construir una imagen propia que incluya
la página de Olympus para reproducir el despliegue.

