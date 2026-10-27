# Día 18 — Versiones de imágenes y rollback

## Objetivo
Desplegar una nueva versión de Olympus, detectar un error de
contenido y recuperar la versión anterior.

## Versiones utilizadas
- olympus-web:0.1 — ID mostrado: 5cd9948b6048.
  Contenido correcto: ambiente desarrollo.
- olympus-web:0.2 — ID mostrado: 73798e4ea46d.
  Error controlado: ambiente producción.

La versión 0.2 se construyó con:
 sudo docker build -t olympus-web:0.2 .

Se conservó la imagen 0.1 sin sobrescribir su etiqueta.

## Despliegue
Se detuvo olympus-web-v01 y se creó olympus-web-v02:

 sudo docker stop olympus-web-v01
 sudo docker run -d --name olympus-web-v02 -p 127.0.0.1:8081:80 olympus-web:0.2

La sustitución conservó la dirección de acceso y tuvo una breve
interrupción entre detener una versión e iniciar la otra.

## Validación
La versión 0.2 respondió HTTP 200, pero mostró "Ambiente: producción".
El criterio de aceptación exigía "Ambiente: desarrollo".

Conclusión: una respuesta HTTP exitosa no garantiza que el
contenido de la aplicación sea correcto.

## Rollback realizado
Se recuperó el contenedor anterior que habíamos conservado:

 sudo docker stop olympus-web-v02
 sudo docker start olympus-web-v01

Se verificó:
- olympus-web-v01 en ejecución, usando olympus-web:0.1.
- Página con ambiente desarrollo y versión 0.1 en localhost:8081.
- olympus-web-v02 detenido con Exited (0).

No fue necesario reconstruir la imagen ni copiar HTML al contenedor.

## Restauración del código fuente
El rollback del servicio no modificó los archivos fuente.

Desde la raíz del repositorio en WSL se restauró el HTML:
 git restore --source=HEAD -- docker/nginx/index.html

Después se transfirió el archivo restaurado al contexto de
construcción de la VM:
 /home/olympus/build/olympus-web/index.html

La imagen 0.2 conserva el contenido defectuoso del ejercicio,
aunque el archivo fuente se haya restaurado.

## Aprendizajes y límites
- Una etiqueta identifica una referencia y puede reasignarse.
- Construir una imagen no actualiza contenedores existentes.
- Validar disponibilidad y validar contenido son comprobaciones distintas.
- El rollback requiere una versión anterior disponible y comprobada.
- En esta práctica se reutilizó el contenedor anterior detenido.
- No se implementó un despliegue sin interrupciones.
- La prueba utilizó una página estática; no incluyó migraciones
  ni recuperación de datos de una base de datos.
