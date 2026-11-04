# Día 20 — Volúmenes y persistencia

## Objetivo
Comprobar qué ocurre con los archivos al reiniciar o reemplazar
un contenedor, y conservar datos mediante un volumen con nombre.

## Entorno
- Host Docker: olympus-node01.
- Imagen utilizada: olympus-web:0.3.
- Variables: OLYMPUS_APP_NAME y OLYMPUS_ENV.
- No se publicaron puertos: se comprobaron archivos con docker exec.

## Prueba sin volumen
Contenedor: olympus-storage-local.
Archivo: /data/registro.txt.
Contenido: Registro 001 de Olympus.

docker inspect mostró Mounts: [].

Resultados:
- Tras docker restart, el archivo permaneció.
- Tras detener, eliminar y recrear el contenedor, el archivo no existía.

El archivo pertenecía a la capa de escritura del contenedor.
No se incorporó a la imagen.

## Prueba con volumen
Se creó el volumen:
 sudo docker volume create olympus-data

Se montó en olympus-storage-volume mediante:
 --mount type=volume,source=olympus-data,target=/data

Se escribió /data/registro.txt con el contenido:
 Registro persistente 001 de Olympus

El montaje mostró:
- Type: volume.
- Name: olympus-data.
- Destination: /data.
- RW: true.
- Driver: local.

## Validación de persistencia
Se detuvo y eliminó olympus-storage-volume.
docker volume ls confirmó que olympus-data permanecía.

Se creó olympus-storage-volume-v2 desde la misma imagen,
montando el mismo volumen en /data.

Sin volver a escribir el archivo, se recuperó:
 Registro persistente 001 de Olympus

## Aprendizajes
- docker exec ejecuta comandos dentro de un contenedor activo.
- Reiniciar conserva la capa de escritura del mismo contenedor.
- Eliminar el contenedor elimina su capa de escritura.
- Un volumen con nombre puede reutilizarse en otro contenedor.
- Los archivos escritos fuera del montaje siguen perteneciendo
  a la capa de escritura del contenedor.
- Reutilizar el nombre del contenedor no recupera sus archivos.
- Conectar el mismo volumen permite acceder a los datos conservados.

## Decisión para Olympus
La página HTML puede regenerarse desde la plantilla y las variables.
Los datos que deban sobrevivir al reemplazo de una instancia
necesitan almacenamiento independiente, como un volumen.

## Límites y estado final
- olympus-storage-volume-v2 conserva el montaje olympus-data en /data.
- El volumen permanece en el almacenamiento local de la VM.
- Un volumen no es un respaldo.
- No se implementaron respaldos ni restauración de bases de datos.
- El archivo de registro es una prueba de almacenamiento;
  Nginx no lo utiliza como dato de aplicación.
