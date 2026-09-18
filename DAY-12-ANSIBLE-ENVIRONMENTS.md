# Project Olympus — Day 12: Ansible Environments

## Estado

Día 12 completado.

## Objetivo

Separar Project Olympus en ambientes de desarrollo y producción simulada mediante inventarios y variables independientes.

## Arquitectura anterior

Olympus utilizaba un único inventario:

```text
ansible/inventory/
├── hosts.ini
├── group_vars/linux.yml
└── host_vars/
