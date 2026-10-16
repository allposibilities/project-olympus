# Día 17 — Dockerfile e imagen propia

## Objetivo
Incluir la página de Olympus en una imagen para crear contenedores
sin copiar el HTML manualmente después del despliegue.

## Archivos fuente
- docker/nginx/Dockerfile
- docker/nginx/index.html

## Dockerfile
FROM nginx:stable
COPY index.html /usr/share/nginx/html/index.html

FROM define la imagen base.
COPY incorpora el HTML desde el contexto de construcción.
Se hereda la configuración de arranque de la imagen Nginx.

## Construcción
Los archivos se editaron en WSL y se transfirieron mediante SSH/SCP a:
 /home/olympus/build/olympus-web

Desde esa carpeta, en olympus-node01:
 sudo docker build -t olympus-web:0.1 .

El punto define el directorio actual como contexto de construcción.
La imagen se guardó localmente; no se publicó en un registry.

## Ejecución
 sudo docker run -d --name olympus-web-v01 -p 127.0.0.1:8081:80 olympus-web:0.1

- Nombre del contenedor: olympus-web-v01.
- Imagen: olympus-web:0.1.
- Entrada en la VM: 127.0.0.1:8081.
- Puerto interno del contenedor: 80.

## Validaciones
- Puerto 8080: página del Día 16.
- Puerto 8081: página del Día 17, versión 0.1.
- Se detuvo y eliminó olympus-web-v01.
- Se creó otro contenedor desde la misma imagen.
- El ID cambió y la página siguió disponible sin docker cp.

## Aprendizajes
- docker build construye imágenes; docker run crea contenedores.
- Nombre e ID del contenedor son conceptos diferentes.
- Podemos reutilizar un nombre después de eliminar su contenedor.
- Cada contenedor tiene su propio entorno de red en este modo.
- Los puertos internos pueden repetirse entre contenedores.
- Las publicaciones en la VM deben evitar conflictos.
- Repetir docker run con un nombre existente no es idempotente.

## Límites
- El HTML contiene datos estáticos.
- nginx:stable es una etiqueta mutable: una futura construcción
  podría utilizar una base distinta.
- Recrear desde la misma imagen local fue validado.
- No se configuró reinicio automático ni acceso desde WSL al servicio.

