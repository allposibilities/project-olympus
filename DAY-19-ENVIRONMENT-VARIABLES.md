# Día 19 - Variables de entorno y configuración

## Objetivo 
Ejecutar la misma imagen de Olympus con distintas configuraciones,
sin reconstruirla para cada ambiente.

## Implementación
Imagen construida: olympus-web:0.3.
ID mostrado: b649ac410a34.

Archivos:
- docker/nginx/Dockerfile
- docker/nginx/index.html.template
- docker/nginx/40-render-page.sh

El Dockerfile incorpora la plantilla y el script.
Durante la construcción, chmod otorga permiso de ejecución al script.

Durante el arranque, el entrypoint de Nginx ejecuta
/docker-entrypoint.d/40-render-page.sh.

El script:
1. Exige OLYMPUS_APP_NAME y OLYMPUS_ENV, definidas y no vacías.
2. Usa envsubst para sustituir esas variables en la plantilla.
3. Escribe /usr/share/nginx/html/index.html.

Después continúa el arranque de Nginx.

## Error controlado
Se creó olympus-web-missing-env sin OLYMPUS_ENV.

Resultado:
- Estado Exited (2).
- Log: OLYMPUS_ENV: Debes definir OLYMPUS_ENV.
- La validación impidió continuar el arranque con configuración incompleta.

## Ejecuciones correctas
Ambos contenedores utilizan olympus-web:0.3.

Desarrollo:
- Contenedor: olympus-web-dev.
- Publicación: 127.0.0.1:8082 hacia el puerto 80.
- OLYMPUS_APP_NAME=Project Olympus.
- OLYMPUS_ENV=desarrollo.

Pruebas:
- Contenedor: olympus-web-testito.
- Publicación: 127.0.0.1:8083 hacia el puerto 80.
- OLYMPUS_APP_NAME=Olympus - Pruebas.
- OLYMPUS_ENV=pruebas.

## Evidencias
- curl devolvió las páginas con sus respectivos valores.
- No quedaron marcadores pendientes de sustitución.
- docker inspect mostró el mismo identificador de imagen
  para ambos contenedores.

## Aprendizajes y límites
- -e proporciona variables de entorno al crear un contenedor.
- Las variables no modifican automáticamente un HTML.
- Nuestro script genera la página durante el arranque.
- Construcción y configuración de ejecución son etapas diferentes.
- docker start conserva la configuración del contenedor existente;
  para cambiar estos valores usaremos un contenedor nuevo.
- Las variables utilizadas son valores no sensibles.
- envsubst sustituye texto, pero no escapa HTML:
  esta práctica utiliza valores controlados.
- Ambos ambientes simulados están en la misma VM.
- index.html permanece como archivo histórico; el nuevo Dockerfile
  utiliza index.html.template.
