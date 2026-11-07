# Día 22 — Docker Compose

## Objetivo
Definir y administrar los componentes de Olympus mediante un
archivo YAML versionado, evitando repetir comandos docker run.

## Configuración
Archivo fuente: compose.yml, en la raíz del repositorio WSL.
Copia de ejecución: /home/olympus/compose/compose.yml, en la VM.
Docker Compose verificado: v5.6.0.

Proyecto: olympus.
Servicios: web y client.
Imagen utilizada por ambos: olympus-web:0.3.
Red declarada: app, driver bridge.
Red creada por Compose: olympus_app.

## Servicios
web conserva el entrypoint de la imagen y recibe:
- OLYMPUS_APP_NAME=Olympus - Compose.
- OLYMPUS_ENV=laboratorio.

client reemplaza el entrypoint por /bin/sh y ejecuta:
 -c 'sleep infinity'

El cliente permanece disponible para ejecutar pruebas.
No inicia Nginx ni genera la página.

## Validación y arranque
Desde /home/olympus/compose en la VM:

 sudo docker compose -f compose.yml config
 sudo docker compose -f compose.yml up -d
 sudo docker compose -f compose.yml ps -a

config validó y mostró la configuración normalizada.
up creó la red y los dos contenedores.
Ambos servicios quedaron en estado Up.

## Comunicación
Desde el servicio client:

 sudo docker compose -f compose.yml exec client getent hosts web
 sudo docker compose -f compose.yml exec client curl -fsS --connect-timeout 3 --max-time 5 http://web:80

Se obtuvo la página Olympus - Compose, ambiente laboratorio.

Los logs de web registraron GET / con código 200:
 sudo docker compose -f compose.yml logs --tail 5 web

No se publicaron puertos en la VM.

## Repetición sin cambios
Se compararon los IDs con:
 sudo docker compose -f compose.yml ps -q

Después de repetir up -d, ambos IDs permanecieron iguales.
Compose conservó los contenedores con la configuración e imagen existentes.

## Eliminación y recreación
Se ejecutó:
 sudo docker compose -f compose.yml down
 sudo docker compose -f compose.yml up -d

down eliminó los contenedores del proyecto y su red.
up creó nuevamente esos recursos con IDs de contenedor diferentes.

La IP observada de web cambió:
- Antes: 172.19.0.3.
- Después: 172.19.0.2.

La petición a http://web:80 siguió funcionando sin cambios.

## Aprendizajes
- El archivo Compose describe servicios y sus relaciones.
- -f selecciona el archivo de configuración.
- Compose identifica sus recursos mediante el proyecto y etiquetas.
- exec client ejecuta un comando dentro del servicio client.
- En una URL, web se resuelve mediante la red Docker.
- logs web selecciona el servicio mediante Compose.
- Los nombres de servicio evitan depender de IP asignadas.
- Repetir up sin cambios y recrear mediante down/up son operaciones distintas.

## Límites
- La imagen 0.3 debe estar disponible; este archivo no define su construcción.
- No se configuraron healthchecks ni espera de disponibilidad.
- Ambos servicios se ejecutan en una sola VM.
- No se declararon volúmenes ni políticas de reinicio.
- La página conserva el texto del Día 19 porque reutilizamos esa imagen.
