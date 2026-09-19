# Project Olympus — Day 13: Ansible Vault

## Estado

Día 13 completado.

## Objetivo

Proteger variables sensibles almacenadas en Git utilizando Ansible Vault y separar las identidades de desarrollo y producción.

## Problema

Las contraseñas, tokens y credenciales no deben guardarse en texto plano:

```yaml
api_token: texto-plano
