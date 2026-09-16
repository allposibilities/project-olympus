# Project Olympus — Day 11: Ansible Role Defaults

## Estado

Día 11 completado.

## Objetivo

Convertir valores fijos del role `nginx` en variables configurables, manteniendo la funcionalidad y la idempotencia.

## Distribución actual de variables

| Variable | Ubicación | Alcance |
|---|---|---|
| `nginx_package_name` | `roles/nginx/defaults/main.yml` | Valor predeterminado del role |
| `application_name` | `inventory/group_vars/linux.yml` | Todos los hosts del grupo `linux` |
| `server_role` | `inventory/host_vars/<host>.yml` | Un host específico |

## Defaults agregados

Archivo:

```text
ansible/roles/nginx/defaults/main.yml
