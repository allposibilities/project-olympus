# PROJECT OLYMPUS — CONTEXTO MAESTRO

## 1. Objetivo del proyecto

Project Olympus es un proyecto práctico y progresivo de aprendizaje DevOps/Cloud.

El objetivo no es estudiar herramientas de forma aislada ni acumular tecnologías por conocerlas superficialmente.

El objetivo es construir progresivamente una plataforma/laboratorio real donde cada nueva herramienta aparezca porque resuelve una necesidad que Olympus ya tiene.

Objetivo profesional del estudiante:

- Transicionar desde practicante profesional hacia un puesto DevOps Junior / Cloud Junior.
- Mercado principal: Perú.
- Construir conocimientos suficientes para postular posteriormente a posiciones Junior.
- Generar un proyecto demostrable que pueda servir como experiencia práctica/portafolio.
- Entender las tecnologías y no limitarse a copiar comandos.

La ruta debe combinar progresivamente:

- Linux
- Networking
- Git/GitHub
- SSH
- Ansible
- AWX
- Docker
- CI/CD
- Jenkins
- SonarQube
- Trivy
- Terraform
- Cloud (AWS/Azure)
- Kubernetes
- Helm
- Observabilidad
- Prometheus/Grafana
- DevSecOps
- Troubleshooting
- Proyecto integrador final


---

# 2. Filosofía de aprendizaje

Olympus debe continuar como un único proyecto acumulativo.

NO convertir las sesiones en tutoriales desconectados como:

"Hoy Kubernetes"
"mañana Terraform"
"después Docker"

Cada tecnología debe introducirse cuando exista un problema concreto que justifique utilizarla.

Método preferido de aprendizaje:

1. Explicar concepto.
2. Relacionarlo con algo que ya existe en Olympus.
3. Mostrar arquitectura/diagrama conceptual.
4. Pedir predicción antes de ejecutar cuando sea útil.
5. Ejecutar comando.
6. Analizar salida real.
7. Explicar por qué ocurrió.
8. Provocar pequeños errores controlados cuando aporten aprendizaje.
9. Corregirlos entendiendo la causa.
10. Comprobar idempotencia/estado.
11. Git commit + push al cerrar una etapa.

No avanzar demasiado rápido.

Es preferible comprender profundamente una herramienta antes de introducir la siguiente.

El estudiante suele preguntar:

"¿En qué porcentaje del día voy?"

Se puede indicar un porcentaje aproximado del progreso del día.

No entregar simplemente grandes bloques de comandos para copiar. Explicar qué estamos haciendo y por qué.


---

# 3. Entorno del laboratorio

## Control Node

Equipo:

Windows 11
ASUS TUF Gaming F15

WSL2 Ubuntu utilizado como Ansible Control Node.

Usuario:

davidbenites

Repositorio:

~/Projects/project-olympus

Prompt habitual:

davidbenites@ASUSF15:~/Projects/project-olympus$

Ansible se ejecuta desde WSL.

SSH key:

~/.ssh/id_ed25519

La clave privada tiene passphrase.

Importante:

La passphrase protege la clave privada local.

NO es la contraseña del usuario remoto.

Los playbooks con:

become: true

actualmente requieren:

-K

para solicitar la contraseña sudo/become.


---

# 4. Managed Nodes actuales

Existen dos máquinas virtuales Ubuntu en VMware.

## olympus-node01

Hostname:

olympus-node01

IP DHCP actual conocida:

192.168.81.136

Rol lógico:

Web Primary


## olympus-node02

Hostname:

olympus-node02

IP DHCP actual conocida:

192.168.81.135

Rol lógico:

Web Secondary


Usuario remoto:

olympus


Red VMware:

192.168.81.0/24

Gateway observado:

192.168.81.2

Dirección host/WSL utilizada en pruebas:

192.168.81.1


IMPORTANTE:

Las IP son DHCP.

NO asumir que siempre permanecerán iguales.

Si Ansible deja de conectar, comprobar primero:

hostname
ip -br a

y compararlo con:

ansible/inventory/hosts.ini


---

# 5. Node02 — historia del clon

olympus-node02 se creó haciendo Full Clone de olympus-node01.

Inicialmente heredó:

- hostname de node01
- /etc/hosts
- Nginx
- página Olympus
- authorized_keys
- machine-id
- posiblemente SSH server host keys

Se corrigió el hostname:

sudo hostnamectl set-hostname olympus-node02

/etc/hosts se cambió a:

127.0.1.1 olympus-node02


Se detectó machine-id duplicado.

Node02 tenía inicialmente el mismo machine-id que node01.

Se regeneró en node02:

sudo rm -f /etc/machine-id
sudo dbus-uuidgen --ensure=/etc/machine-id
sudo reboot

Node02 terminó con machine-id diferente.

Las MAC de ambas máquinas son diferentes.

Node01:

00:0c:29:30:32:52

Node02:

00:0c:29:bf:22:56


IMPORTANTE:

No afirmar que el machine-id duplicado fue necesariamente la causa del DHCP repetido.

Cuando node01 estaba apagado, node02 podía recibir .135.

Al encender ambas simultáneamente:

node01 -> .136
node02 -> .135

Funcionaron correctamente.


PENDIENTE TÉCNICO:

No se ha verificado/regenerado explícitamente si node02 conserva SSH server host keys clonadas.

Esto puede revisarse posteriormente como tema de identidad/hardening.


---

# 6. Inventario Ansible

Archivo:

ansible/inventory/hosts.ini

Conceptualmente:

[linux]
olympus-node01 ansible_host=192.168.81.136 ansible_user=olympus
olympus-node02 ansible_host=192.168.81.135 ansible_user=olympus

Puede contener parámetros adicionales.

NO eliminar parámetros existentes sin revisarlos.


---

# 7. ansible.cfg

Project Olympus utiliza ansible.cfg.

Entre otras configuraciones, actualmente debe conocer:

inventory = ./ansible/inventory/hosts.ini

y desde Día 9:

roles_path = ./ansible/roles

Esto permite ejecutar comandos sin escribir -i constantemente y permite encontrar los roles ubicados en:

ansible/roles/


---

# 8. Conceptos importantes ya aprendidos

El estudiante ya comprende:

- Linux CLI básico
- sudo
- permisos básicos
- networking básico
- ICMP
- TCP
- SSH
- autenticación por clave pública
- Git básico
- repositorios
- Ansible ad-hoc
- inventories
- playbooks
- modules
- become
- idempotencia
- facts
- gather_facts
- ansible_facts
- variables
- group_vars
- host_vars
- Jinja básico
- templates
- handlers
- notify
- multi-host
- Ansible Roles
- defaults de roles
- vars de roles
- precedencia básica de variables


---

# 9. Distinciones conceptuales que ya fueron enseñadas

## ICMP ping vs Ansible ping

ping normal:

Comprueba principalmente conectividad de red mediante ICMP.

ansible.builtin.ping:

Comprueba aproximadamente:

Control Node
    ->
SSH
    ->
autenticación
    ->
Python remoto
    ->
ejecución del módulo
    ->
pong


---

## Facts vs variables propias

ansible_facts:

Datos descubiertos desde el servidor.

Ejemplos:

ansible_facts["hostname"]
ansible_facts["distribution"]
ansible_facts["memtotal_mb"]


group_vars / host_vars:

Variables definidas por nosotros.


IMPORTANTE:

ansible_host NO es un fact.

Es una inventory/connection variable.

Ejemplo:

ansible_host=192.168.81.136

le dice a Ansible dónde conectarse.


---

## Jinja

Sintaxis básica:

{{ expression }}

Jinja renderiza variables.

Jinja NO consulta directamente el servidor.

Ansible obtiene facts/variables y Jinja utiliza esos valores para renderizar contenido.


---

## Idempotencia

Concepto muy bien comprendido.

Si el servidor ya está en el estado deseado:

changed=0

Ejecutar nuevamente el playbook no debería producir cambios innecesarios.


IMPORTANTE:

--check NO significa automáticamente changed=0.

--check predice qué cambiaría.

Puede mostrar changed>0 sin aplicar realmente el cambio.


---

## Handler

Flujo:

task
  ->
changed=true
  ->
notify
  ->
handler

Si task:

changed=false

no se notifica el handler.

El handler no es quien determina la idempotencia.


---

# 10. DAY 1 — WSL / entorno inicial

Objetivos iniciales:

- preparar entorno de trabajo
- utilizar WSL2 Ubuntu
- trabajar desde terminal Linux
- integración con VS Code
- comenzar estructura Project Olympus

Se estableció WSL como futura máquina de control del laboratorio.


---

# 11. DAY 2 — Git / GitHub / SSH

Se trabajó:

- repositorio Git
- GitHub
- SSH
- autenticación
- conexión al repositorio
- estructura inicial de Project Olympus

Repositorio:

~/Projects/project-olympus

Branch principal:

main

Remote histórico:

git@github.com:allposibilities/project-olympus.git


---

# 12. DAY 3 — Git internals / workflow

Se profundizó en:

- working tree
- staging area
- commits
- relación entre archivos locales y repositorio
- git add
- git commit
- git push
- lectura de git status
- flujo de trabajo

Git se utiliza al cierre de los días importantes de Olympus.


---

# 13. DAY 4 — Linux

Se trabajaron fundamentos Linux necesarios para administrar servidores.

Conceptos relevantes para Olympus:

- filesystem
- archivos/directorios
- comandos
- usuarios
- permisos
- sudo
- servicios
- navegación
- operaciones básicas de administración

Objetivo:

no utilizar Ansible sin comprender qué operaciones Linux está automatizando.


---

# 14. DAY 5 — Networking + SSH

Se trabajó:

- IP
- interfaces
- conectividad
- ICMP
- TCP
- puertos
- SSH
- autenticación mediante claves
- comunicación Control Node -> Managed Node

Se estableció la base para que Ansible pudiera administrar remotamente los servidores.


---

# 15. DAY 6 — Ansible fundamentals

Se introdujo Ansible.

Conceptos:

- Control Node
- Managed Node
- Inventory
- Modules
- ad-hoc commands
- Playbooks
- SSH como transporte
- Python remoto
- become
- idempotencia

Se automatizó Nginx inicialmente.

Arquitectura:

WSL
 |
Ansible
 |
SSH
 |
olympus-node01


Se entendió que Ansible normalmente no necesita un agente instalado permanentemente en el managed node.


---

# 16. DAY 7 — Facts + Variables + Jinja + Templates + Handlers

Día completado 100%.


## ansible.cfg

Se configuró el proyecto para localizar automáticamente inventory.


## Facts

Se utilizó:

ansible.builtin.setup

Se aprendió que gather_facts obtiene información del servidor.

Ejemplos:

ansible_facts["distribution"]
ansible_facts["hostname"]
ansible_facts["memtotal_mb"]


Se observó aproximadamente:

Ubuntu
1927 MB RAM


Ansible-core 2.20 muestra warning relacionado con fact injection.

Evitar preferentemente:

ansible_distribution

Preferir:

ansible_facts["distribution"]


## gather_facts

Con:

gather_facts: true

facts disponibles.

Con:

gather_facts: false

facts no necesariamente disponibles.


## group_vars

Archivo:

ansible/inventory/group_vars/linux.yml

Variable:

application_name: Project Olympus


## Jinja

Ejemplo:

{{ application_name }}

y:

{{ ansible_facts['hostname'] }}


## Template Nginx

Se creó:

index.html.j2

con información dinámica:

Project Olympus
hostname
Operating System


## Handler

Se utilizó:

notify: Reload Nginx

Handler:

Reload Nginx


Se comprobó:

template changed
 ->
handler ejecutado

segunda ejecución:

template ok
 ->
handler no ejecutado


## Idempotencia

Segunda ejecución:

changed=0

Día 7 cerrado con Git commit/push.


---

# 17. DAY 8 — Multi-host + host_vars

Día completado 100%.

Se añadió:

olympus-node02

Topología:

                WSL
                 |
              Ansible
                 |
            grupo linux
             /      \
            /        \
      node01          node02
   Web Primary     Web Secondary


## group_vars

Compartido:

application_name: Project Olympus


## host_vars

Archivo:

ansible/inventory/host_vars/olympus-node01.yml

server_role: Web Primary


Archivo:

ansible/inventory/host_vars/olympus-node02.yml

server_role: Web Secondary


Se comprendió:

group_vars
 -> configuración compartida por grupo

host_vars
 -> configuración específica por host

ansible_facts
 -> información descubierta del servidor

ansible_host
 -> variable de conexión/inventory


## facts.yml multi-host

Se mostró:

Project Olympus - olympus-node01 - Web Primary

Project Olympus - olympus-node02 - Web Secondary


Ambos aproximadamente:

1927 MB RAM


## Template multi-host

El mismo template empezó a utilizar:

{{ server_role }}

Resultado:

node01:
Web Primary

node02:
Web Secondary


Mismo:

- playbook
- template
- group vars

pero distinta configuración por host.


Se validó mediante curl.

Idempotencia final:

node01 changed=0
node02 changed=0

Día 8 cerrado con Git.


---

# 18. DAY 9 — Ansible Roles

Día completado 100%.

Objetivo:

refactorizar Nginx desde un playbook monolítico hacia un Ansible Role.


ANTES:

nginx.yml
 |
 +-- tasks
 +-- handlers

templates/index.html.j2


DESPUÉS:

ansible/
 |
 +-- playbooks/
 |     |
 |     +-- nginx.yml
 |
 +-- roles/
       |
       +-- nginx/
             |
             +-- tasks/main.yml
             +-- handlers/main.yml
             +-- templates/index.html.j2
             +-- defaults/main.yml
             +-- vars/main.yml
             +-- meta/main.yml
             +-- ...


Se creó inicialmente mediante:

ansible-galaxy role init ansible/roles/nginx


## Error aprendido: roles_path

Inicialmente:

roles:
  - nginx

produjo:

role 'nginx' was not found

porque Ansible no buscaba en:

ansible/roles/

Se añadió a ansible.cfg:

roles_path = ./ansible/roles


Esto permitió utilizar simplemente:

roles:
  - nginx


## Error aprendido: typo builtin

Se escribió accidentalmente:

ansible.bultin.service

y Ansible produjo:

couldn't resolve module/action

Se corrigió a:

ansible.builtin.service


## Playbook después del refactor

Conceptualmente:

---
- name: Configure Nginx web server
  hosts: linux
  become: true

  roles:
    - nginx


Se comprendió:

PLAYBOOK
 -> dónde y bajo qué contexto ejecutar

ROLE
 -> cómo implementar una responsabilidad


Por eso:

hosts: linux
become: true

permanecen en el playbook.

No se trasladan a subcarpetas del role.


## tasks/main.yml

Contiene:

- instalación Nginx
- servicio enabled/running
- despliegue template


## handlers/main.yml

Contiene:

Reload Nginx


## templates/

El template pasó a:

roles/nginx/templates/index.html.j2

Dentro del role:

src: index.html.j2

porque Ansible conoce la estructura estándar del role.


## Validación del refactor

Syntax:

ansible-playbook ansible/playbooks/nginx.yml --syntax-check

OK.


Check mode:

node01:
ok=4 changed=0

node02:
ok=4 changed=0


Real execution:

node01:
changed=0

node02:
changed=0


curl node01:

Project Olympus
Server: olympus-node01
Role: Web Primary
Operating System: Ubuntu


curl node02:

Project Olympus
Server: olympus-node02
Role: Web Secondary
Operating System: Ubuntu


Esto demostró:

misma funcionalidad
+
nueva arquitectura interna
+
idempotencia preservada


---

# 19. DAY 9 — Role defaults

Se introdujo:

roles/nginx/defaults/main.yml

Variable útil:

nginx_package_name: nginx


Task cambió de:

name: nginx

a:

name: "{{ nginx_package_name }}"


Resultado:

changed=0


Se comprendió que:

defaults/main.yml

contiene valores predeterminados pensados para poder sobrescribirse.


---

# 20. DAY 9 — Precedencia: defaults vs group_vars

Se realizó un experimento controlado.

Role default:

nginx_environment: role-default

group_vars:

nginx_environment: linux-group


Debug devolvió:

Nginx environment: linux-group


Se comprobó:

group_vars > role defaults


Después se eliminó group_var y se comprobó que se utilizaba:

role-default


Concepto:

si existe override
 -> usar override

si no existe
 -> utilizar default


---

# 21. DAY 9 — vars/main.yml

Se realizó segundo experimento.

roles/nginx/vars/main.yml:

nginx_role_type: role-vars

group_vars/linux.yml:

nginx_role_type: group-vars


Resultado:

Nginx role type: role-vars


Se comprobó:

role vars > group_vars


Regla práctica aprendida:

defaults/main.yml
 -> valores configurables/predeterminados

vars/main.yml
 -> variables más internas del role


No memorizar todavía toda la tabla completa de precedencia de Ansible.

Se aprenderá progresivamente.


---

# 22. Estado final del Día 9

Después de limpiar variables/debug experimentales:

roles/nginx/defaults/main.yml

mantiene:

---
nginx_package_name: nginx


vars/main.yml puede quedar esencialmente vacío.


Validación final:

olympus-node01:
ok=4 changed=0 failed=0

olympus-node02:
ok=4 changed=0 failed=0


Git:

commit + push completados.

DÍA 9 = 100%.


---

# 23. ESTADO ACTUAL EXACTO

El próximo contenido todavía NO se ha iniciado formalmente.

El siguiente es:

DAY 10


Se había propuesto empezar con:

- Ansible Tags
- ejecución selectiva
- organización operacional del role

pero el usuario pidió primero generar este contexto maestro para migrar a otro proyecto/chat.

Por lo tanto:

DÍA 10 = 0%

NO asumir que Tags ya fueron practicados.


---

# 24. Próximo DAY 10 recomendado

Tema:

Ansible Tags + ejecución selectiva.


Problema a resolver:

El role Nginx crecerá.

No siempre queremos ejecutar conceptualmente:

install
service
deploy

Podemos etiquetar tareas.


Ejemplo futuro:

- name: Ensure Nginx is installed
  ...
  tags:
    - install

- name: Ensure Nginx is enabled and running
  ...
  tags:
    - service

- name: Deploy Olympus web page
  ...
  tags:
    - deploy


Aprender:

--list-tags
--list-tasks
--tags
--skip-tags


Realizar experimento:

modificar template
 ->
ejecutar únicamente tag deploy
 ->
observar changed
 ->
observar notify
 ->
observar handler


IMPORTANTE:

Tags no reemplazan roles.

No crear roles gigantes llenos de tags.


---

# 25. Roadmap futuro de Olympus

El orden puede adaptarse según necesidades, pero debe conservar dependencias pedagógicas.

La intención general es:


FASE 1 — FUNDAMENTOS
====================

[x] Git
[x] Linux
[x] Networking
[x] SSH
[x] Ansible fundamentals
[x] Facts
[x] Variables
[x] Templates
[x] Handlers
[x] Multi-host
[x] Roles

A continuación profundizar:

[ ] Tags
[ ] variables/defaults más reales
[ ] organización de ambientes
[ ] Ansible Vault
[ ] secrets
[ ] troubleshooting Ansible


---

FASE 2 — DOCKER / CONTAINERS
============================

Aprender:

[ ] containers vs VMs
[ ] images
[ ] Dockerfile
[ ] docker build
[ ] docker run
[ ] ports
[ ] volumes
[ ] networks
[ ] environment variables
[ ] Docker Compose
[ ] registry

No enseñar Docker aisladamente.

Construir/contener componentes reales de Olympus.


---

FASE 3 — APLICACIÓN OLYMPUS
===========================

Crear una aplicación sencilla que permita practicar DevOps.

Posibles componentes conceptuales:

frontend
backend
Nginx
persistencia

El objetivo NO es convertirse en desarrollador full-stack.

La aplicación existe para tener algo real que:

- construir
- probar
- contenerizar
- desplegar
- escanear
- monitorear


---

FASE 4 — CI/CD
==============

Integrar Jenkins.

El usuario ya tiene exposición laboral a Jenkins.

Aprender progresivamente:

[ ] pipeline
[ ] stages
[ ] checkout
[ ] build
[ ] tests
[ ] artifacts
[ ] environment variables
[ ] credentials
[ ] Docker build
[ ] deployment
[ ] rollback básico


Flujo conceptual:

Developer
   |
   v
Git
   |
   v
Jenkins
   |
   +--> Test
   |
   +--> Build
   |
   +--> Security
   |
   v
Deploy


---

FASE 5 — DEVSECOPS / TRIVY
==========================

La empresa del usuario utiliza Trivy.

Trivy debe introducirse cuando Olympus ya produzca imágenes Docker.

Aprender:

[ ] vulnerability scanning
[ ] image scanning
[ ] filesystem/repository scanning cuando corresponda
[ ] severidades
[ ] interpretación de findings
[ ] integración CI/CD
[ ] security gate básico


Ejemplo conceptual:

Git push
   |
Jenkins
   |
Tests
   |
SonarQube
   |
Docker Build
   |
Trivy Scan
   |
¿cumple política?
 /          \
NO          SÍ
|            |
FAIL       Deploy


No utilizar Trivy únicamente para ejecutar comandos; interpretar resultados.


---

FASE 6 — TERRAFORM
==================

El usuario comenta que pocas personas de su entorno laboral conocen Terraform.

Debe aprenderse de manera práctica.

Distinción fundamental:

Terraform:
CREAR/PROVISIONAR infraestructura

Ansible:
CONFIGURAR infraestructura


Ejemplo:

Terraform
   |
   +--> Network
   +--> VM
   +--> Security Group
   +--> Load Balancer
   |
infraestructura existe
   |
Ansible
   |
   +--> paquetes
   +--> usuarios
   +--> configuración
   +--> aplicaciones


Aprender:

[ ] providers
[ ] resources
[ ] terraform init
[ ] terraform plan
[ ] terraform apply
[ ] terraform destroy
[ ] variables
[ ] outputs
[ ] state
[ ] dependencies
[ ] modules
[ ] remote state cuando corresponda
[ ] buenas prácticas
[ ] integración con cloud


---

FASE 7 — CLOUD
==============

Aplicar Terraform/Ansible sobre infraestructura cloud.

Prioridad profesional:

AWS y/o Azure.

No intentar aprender todos los servicios.

Servicios/conceptos útiles para perfil Junior:

[ ] IAM
[ ] networking/VPC/VNet
[ ] subnets
[ ] compute/VMs
[ ] security groups/NSG
[ ] storage
[ ] load balancing
[ ] DNS básico
[ ] monitoring/logging
[ ] container registry
[ ] secrets cuando corresponda

El objetivo es trasladar conocimientos del laboratorio local a cloud.


---

FASE 8 — AWX
============

La empresa del usuario utiliza AWX.

No tratar AWX simplemente como "Ansible gráfico".

AWX añade una capa operacional sobre Ansible:

- interfaz
- API
- inventories
- credentials
- projects
- job templates
- schedules
- RBAC
- historial de ejecuciones


Ansible sigue siendo la base de automatización.


Olympus debería llegar a:

Git repository
      |
      v
     AWX
      |
      +--> Project
      +--> Inventory
      +--> Credentials
      +--> Job Template
      |
      v
Ansible automation
      |
   +--+--+
   |     |
node01 node02


La ventaja de aprender AWX después de Ansible CLI es que el estudiante podrá entender qué está abstrayendo la interfaz.


---

FASE 9 — KUBERNETES
===================

Kubernetes NO debe enseñarse antes de comprender Docker.

Primero Olympus debe tener aplicaciones containerizadas.

Problemas que Kubernetes resolverá:

- múltiples instancias
- container failure
- service discovery
- scaling
- rolling updates
- configuration
- health checks


Aprender progresivamente:

[ ] cluster architecture básica
[ ] kubectl
[ ] Pod
[ ] Deployment
[ ] ReplicaSet conceptualmente
[ ] Service
[ ] ConfigMap
[ ] Secret
[ ] Namespace
[ ] probes
[ ] resource requests/limits
[ ] rolling updates
[ ] rollback
[ ] Ingress
[ ] persistent storage básico
[ ] troubleshooting


Ejemplo:

              Ingress
                 |
                 v
              frontend
                 |
              Service
                 |
          +------+------+
          |      |      |
          v      v      v
       backend backend backend
         Pod    Pod    Pod


Si un Pod muere:

Pod X
  |
Kubernetes
  |
crea/reemplaza otro


---

FASE 10 — HELM
==============

Después de entender manifests Kubernetes.

Aprender:

[ ] chart
[ ] templates
[ ] values.yaml
[ ] releases
[ ] install
[ ] upgrade
[ ] rollback

No enseñar Helm antes de comprender qué recursos Kubernetes está generando.


---

FASE 11 — OBSERVABILIDAD
========================

Integrar:

Prometheus
Grafana

y logging según evolución del proyecto.


Aprender:

[ ] metrics
[ ] logs
[ ] alerting
[ ] dashboards
[ ] CPU
[ ] memory
[ ] availability
[ ] application metrics
[ ] infrastructure metrics


El usuario ya tiene experiencia laboral relacionada con:

Zabbix
AWS CloudWatch
Elastic/OCC

Conectar conceptualmente esa experiencia con Olympus cuando sea útil.


---

FASE 12 — SECURITY / HARDENING
==============================

Introducir progresivamente:

[ ] Linux hardening
[ ] least privilege
[ ] SSH hardening
[ ] secrets
[ ] Ansible Vault
[ ] IAM
[ ] container security
[ ] image scanning
[ ] Kubernetes security básica
[ ] dependency/image vulnerabilities
[ ] secure CI/CD
[ ] credential management


Revisar también eventualmente el posible problema pendiente de SSH host keys del clon node02.


---

# 26. Arquitectura objetivo aproximada

Al final Olympus debería permitir comprender algo parecido a:


                    DEVELOPER
                        |
                        v
                       Git
                        |
                        v
                     Jenkins
                        |
          +-------------+-------------+
          |             |             |
          v             v             v
        Tests        SonarQube      Trivy
                        |
                        v
                  Docker Registry
                        |
                        v
                    Kubernetes
                  +-----+-----+
                  |  Olympus  |
                  +-----+-----+
                        |
                        v
                  Observability


Terraform
    |
    +--> Infrastructure


Ansible
    |
    +--> Configuration


AWX
    |
    +--> Ansible operational/orchestration layer


Prometheus/Grafana
    |
    +--> Observability


---

# 27. Objetivo profesional final

Al terminar Olympus, el estudiante debería poder explicar en una entrevista Junior:

- cómo funciona Linux en sus servidores
- networking básico
- SSH
- Git workflow
- cómo Ansible administra servidores
- inventories
- variables
- templates
- handlers
- roles
- secrets
- AWX
- containers
- Dockerfiles
- CI/CD
- Jenkins
- vulnerability scanning
- Trivy
- Infrastructure as Code
- Terraform
- cloud fundamentals
- Kubernetes
- Helm
- observabilidad
- troubleshooting
- conceptos DevSecOps

Pero más importante:

Debe poder demostrarlo mediante Project Olympus.


---

# 28. Regla para futuras sesiones

NO reiniciar Project Olympus.

NO volver a explicar desde Día 1 salvo que el estudiante lo solicite.

Continuar desde el estado actual.

ESTADO ACTUAL:

Days 1–9 completados.

Day 9:
100%

Git:
commit/push realizado.

Next:

DAY 10
Ansible Tags + ejecución selectiva.

Comenzar verificando:

cd ~/Projects/project-olympus
git status

Luego continuar desde el role nginx existente.


---

# 29. Forma de enseñanza esperada en el nuevo chat

Actuar como mentor técnico progresivo.

Cuando exista un error:

NO entregar inmediatamente una solución enorme.

Primero:

1. leer error
2. identificar componente
3. explicar qué significa
4. corregir
5. volver a probar

Ejemplos de errores ya encontrados:

role nginx not found
 -> roles_path

ansible.bultin.service
 -> typo
 -> ansible.builtin.service


Utilizar los errores como oportunidades de aprendizaje.


Antes de cambios importantes:

syntax-check
check mode
real execution
validation


Después:

idempotence test


Finalmente:

git status
git diff
git add
git commit
git push


---

# 30. NOTAS IMPORTANTES

Ansible version observada:

ansible-core 2.20.x


Managed-node Python:

/usr/bin/python3.10


Existe warning de interpreter discovery.

No es actualmente un fallo.


Existe warning/deprecación relacionada con fact injection en Ansible moderno.

Preferir:

ansible_facts["distribution"]

en vez de variables legacy inyectadas como:

ansible_distribution


No hardcodear nuevas IP sin comprobarlas porque DHCP puede cambiar.


No introducir herramientas simplemente para aumentar la cantidad de tecnologías.

Cada herramienta debe responder:

"¿Qué problema de Olympus estamos resolviendo con esto?"


FIN DEL CONTEXTO MAESTRO.