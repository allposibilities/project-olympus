# Project Olympus — Day 10: Ansible Tags

## Estado

Día 10 completado.

## Objetivo

Aprender a clasificar y ejecutar selectivamente tareas de un role mediante Ansible Tags, relacionándolos con idempotencia, templates, notificaciones y handlers.

## Cambios realizados

Se agregaron tres tags al role `nginx`:

| Tarea | Tag |
|---|---|
| Ensure Nginx is installed | `install` |
| Ensure Nginx is enabled and running | `service` |
| Deploy Olympus web page | `deploy` |

Archivo modificado:

```text
ansible/roles/nginx/tasks/main.yml
