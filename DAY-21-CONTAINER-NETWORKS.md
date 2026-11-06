# Día 21 — Redes entre contenedores

## Objetivo
Comunicar componentes de Olympus por nombre dentro de una red
Docker, sin publicar el puerto del servidor en la VM.

## Red creada
Comando:
 sudo docker network create --driver bridge olympus-net

Datos observados:
- Nombre: olympus-net.
- Driver: bridge.
- Subred: 172.18.0.0/16.
- Gateway: 172.18.0.1.

Es una red local al host Docker olympus-node01.
La red bridge definida por el usuario proporciona resolución
automática de nombres entre sus contenedores.

## Servidor
- Nombre: olympus-network-web.
- Imagen: olympus-web:0.3.
- Red: olympus-net.
- IP observada: 172.18.0.2.
- Puerto interno: 80.
- Sin publicación de puertos mediante -p.
- OLYMPUS_APP_NAME=Olympus - Redes.
- OLYMPUS_ENV=laboratorio.

## Cliente
- Nombre: olympus-network-client.
- Imagen: olympus-web:0.3.
- Red: olympus-net.
- Entrypoint reemplazado por /bin/sh.
- Comando: -c 'sleep infinity'.

El cliente utiliza las herramientas de la imagen.
No ejecuta el entrypoint habitual ni inicia Nginx.

## Validación inicial
Desde el cliente:
 getent hosts olympus-network-web

Resultado observado:
 172.18.0.2 olympus-network-web

Petición:
 curl -fsS --connect-timeout 3 --max-time 5 http://olympus-network-web:80

Resultado: HTML de Olympus - Redes, ambiente laboratorio.

## Fallo controlado
Se desconectó únicamente el cliente:
 sudo docker network disconnect olympus-net olympus-network-client

La inspección mostró Networks: {}.
La petición falló con:
 curl: (6) Could not resolve host: olympus-network-web

El fallo ocurrió en la resolución del nombre, antes de establecer
una conexión con el puerto 80 del servidor.

## Recuperación
Se reconectó el mismo cliente:
 sudo docker network connect olympus-net olympus-network-client

Se repitieron las consultas:
- El nombre volvió a resolver a 172.18.0.2.
- La petición HTTP volvió a devolver la página.
- No fue necesario recrear los contenedores.

## Aprendizajes y límites
- docker exec ejecuta la consulta dentro del contenedor cliente.
- Compartir red permite conectividad, pero el servicio debe escuchar
  en el puerto de destino.
- La comunicación utilizó el puerto interno 80, sin -p.
- Mostrar 80/tcp en docker ps no significa que esté publicado en la VM.
- La resolución de nombres Docker no se extiende automáticamente a WSL.
- Las IP observadas pueden cambiar; utilizamos nombres para comunicarnos.
- No publicar puertos no equivale a aislamiento absoluto:
  el host Docker puede normalmente acceder a las IP de sus bridges.
- Todos los componentes de esta práctica están en una sola VM.

## Estado final validado
olympus-network-client y olympus-network-web están conectados
a olympus-net y se comunican correctamente por nombre.
