# PROJECT OLYMPUS — CONTEXTO MAESTRO DE APRENDIZAJE

## 0. Propósito de este documento

Este archivo contiene el contexto completo necesario para continuar Project Olympus desde el DÍA 7 en un nuevo chat de ChatGPT.

IMPORTANTE PARA CHATGPT:

No comenzar Project Olympus desde cero.

El usuario ya completó los Días 1–6 y quiere continuar aprendiendo progresivamente.

La metodología debe ser:

1. Aprender haciendo.
2. Explicar antes o después de cada comando:
   - qué hace;
   - qué significa literalmente;
   - por qué se utiliza;
   - qué ocurre internamente;
   - cómo se relaciona con conocimientos anteriores.
3. No entregar solamente comandos para copiar/pegar.
4. Hacer troubleshooting cuando algo falle, en lugar de saltar directamente a la solución.
5. Realizar checkpoints/preguntas periódicas para comprobar comprensión.
6. Corregir conceptos técnicos y vocabulario cuando sea necesario.
7. Integrar conocimientos de Linux, redes, Git, SSH, Ansible, seguridad, automatización, observabilidad, etc.
8. Avanzar por días y llevar aproximadamente un porcentaje de progreso.
9. Priorizar comprensión sobre velocidad.
10. Construir Project Olympus como laboratorio real y como proyecto demostrable profesionalmente.

---

# 1. OBJETIVO GENERAL — PROJECT OLYMPUS

Project Olympus es un laboratorio personal para aprender e integrar:

- Linux
- Git
- GitHub
- SSH
- Ansible
- AWX
- Terraform
- Docker
- Cloud
- Observabilidad
- Hardening
- Automatización de seguridad
- Infraestructura como código
- Troubleshooting
- posteriormente CI/CD y otras integraciones

Objetivo conceptual:

No aprender herramientas aisladas.

Integrarlas dentro de una arquitectura real.

---

# 2. ARQUITECTURA ACTUAL

Equipo físico:

ASUS TUF Gaming F15

Sistema anfitrión:

Windows 11

Arquitectura actual:

Windows 11
│
├── WSL2 Ubuntu
│   │
│   ├── usuario: davidbenites
│   ├── estación de ingeniería
│   ├── Git
│   ├── GitHub SSH
│   ├── VS Code
│   ├── Ansible
│   └── Project Olympus
│
└── VMware Workstation
    │
    └── olympus-node01
        ├── Ubuntu Server 22.04.5 LTS
        ├── usuario: olympus
        ├── IP: 192.168.81.135
        ├── red VMware: NAT
        ├── RAM: 2 GB
        ├── CPU: 2
        ├── disco: 20 GB
        └── SSH Server

Modelo:

WSL2 = CONTROL NODE

olympus-node01 = MANAGED NODE

---

# 3. REPOSITORIO

Ruta local:

/home/davidbenites/Projects/project-olympus

Repositorio GitHub:

git@github.com:allposibilities/project-olympus.git

Branch:

main

Remote:

origin

Estructura inicial:

project-olympus/
├── .git/
├── .gitignore
├── README.md
├── ansible/
├── docs/
├── labs/
└── security/

Commit inicial:

143b66a chore: initialize Project Olympus repository

GitHub ya está configurado mediante SSH.

---

# 4. DÍA 1 — WSL / ENTORNO LINUX

Se preparó WSL2 Ubuntu como estación de ingeniería.

Concepto principal:

Windows 11 = host físico

WSL2 Ubuntu = entorno Linux de trabajo/control.

Ruta de proyectos:

~/Projects

Project Olympus:

~/Projects/project-olympus

VS Code puede abrirse desde WSL mediante:

code .

La primera vez VS Code instaló VS Code Server dentro de WSL.

Ruta observada:

~/.vscode-server/bin/

Después de instalarse correctamente, `code .` abre VS Code inmediatamente sin reinstalar.

Se comprobó:

code --version

VS Code trabaja conectado al filesystem y herramientas Linux de WSL.

---

# 5. DÍA 2 — GIT / GITHUB

Se creó Project Olympus como repositorio Git.

Estructura inicial:

ansible/
docs/
labs/
security/

Se utilizaron `.gitkeep` para mantener directorios inicialmente vacíos.

Se configuró Git.

Se creó commit inicial:

chore: initialize Project Olympus repository

Se configuró GitHub mediante SSH.

Remote:

origin git@github.com:allposibilities/project-olympus.git

Se verificó:

git status
git remote -v
git branch -vv

Estado observado:

On branch main
Your branch is up to date with 'origin/main'.

Se instaló también la extensión:

Codex - OpenAI's coding agent

en Visual Studio Code.

---

# 6. DÍA 3 — GIT INTERNALS

Objetivo:

No tratar Git como una caja negra.

Se inspeccionó:

.git/

Ejemplo:

cd .git
pwd
ls -la

Se observó:

HEAD
config
index
objects
refs
logs
hooks
etc.

Se ejecutó:

cat HEAD

Resultado:

ref: refs/heads/main

Después:

cat refs/heads/main

Resultado:

143b66ac199377b17c213e94c95705999dd1888e

Se comprendió:

HEAD
→ referencia branch main

refs/heads/main
→ contiene hash del commit actual

Se inspeccionó:

git cat-file -t HEAD

Resultado:

commit

Después:

git cat-file -p HEAD

Se observó:

tree <hash>
author
committer
mensaje del commit

Se inspeccionó el tree:

git cat-file -p <TREE_HASH>

Ejemplo observado:

100644 blob ... .gitignore
100644 blob ... README.md
040000 tree ... ansible
040000 tree ... docs
040000 tree ... labs
040000 tree ... security

Se inspeccionó un blob del README:

git cat-file -p <BLOB_HASH>

Se comprendieron los objetos Git:

COMMIT
│
└── TREE
    │
    ├── nombre archivo → BLOB
    ├── nombre archivo → BLOB
    └── directorio → TREE

Conceptos aprendidos:

- blob almacena contenido;
- tree relaciona nombres/rutas con blobs/trees;
- commit referencia un tree;
- Git utiliza hashes;
- contenido idéntico produce el mismo hash;
- Git puede reutilizar blobs existentes;
- Git no necesita duplicar todos los archivos por cada commit.

Respuesta conceptual adquirida:

Git puede almacenar millones de commits eficientemente porque los commits referencian trees/blobs y los objetos de contenido idéntico pueden reutilizarse.

---

# 7. DÍA 4 — FUNDAMENTOS LINUX

Se exploró filesystem:

/home
/etc
/var/log
/proc

Ejemplos:

cd /home
pwd
ls

cd ../etc
pwd
ls | head

Se estudió `/proc`.

Ejemplo:

cd /proc
ls | head

Se comprendió:

/proc es un filesystem virtual expuesto por el kernel.

Directorios numéricos representan procesos:

/proc/<PID>

Ejemplo inspeccionado:

cat /proc/329/cmdline

También:

cat /proc/cpuinfo | head
cat /proc/meminfo | head
cat /proc/uptime

Se relacionó `/proc` con información dinámica del kernel y procesos.

---

## Procesos

Se utilizó:

ps -ef | head

Se observaron:

PID
PPID
UID
CMD

Se inspeccionó la shell:

ps -fp $$

Resultado aproximado:

bash PID 329

Se recorrió árbol de padres:

329
↓
328 /init
↓
327 /init
↓
2 /init
↓
1 /sbin/init

Se comprendieron:

PID = Process ID
PPID = Parent Process ID

PID 1 es proceso raíz del userspace.

---

## Builtins vs ejecutables

Se ejecutó:

type cd

Resultado:

cd is a shell builtin

Después:

type ls

Resultado:

ls is aliased to `ls --color=auto`

Se comprendió que no todos los comandos son ejecutables independientes.

---

## Usuarios / UID / grupos

Se ejecutó:

whoami

Resultado:

davidbenites

También:

id

Resultado incluía:

uid=1000(davidbenites)
gid=1000(davidbenites)

Se comprendió:

Linux/kernel utiliza UID/GID internamente.

Los nombres humanos son una representación más cómoda.

Se inspeccionó:

cat /etc/passwd | grep davidbenites

Resultado:

davidbenites:x:1000:1000::/home/davidbenites:/bin/bash

---

## Permisos Linux

Se trabajó con:

r = read = 4
w = write = 2
x = execute = 1

Ejemplos aprendidos:

rw-r--r-- = 644
rwx------ = 700
rwxr-x--- = 750
rwxrwxrwx = 777

Se comprendió:

owner
group
others

Y la representación octal.

---

# 8. DÍA 5 — SSH

Objetivo:

Construir la infraestructura de acceso remoto antes de Ansible.

---

## Claves SSH

En WSL existen:

~/.ssh/id_ed25519
~/.ssh/id_ed25519.pub

Permisos comprobados:

stat -c '%A %a %U %G %n' ~/.ssh/id_ed25519 ~/.ssh/id_ed25519.pub

Resultado:

-rw------- 600 davidbenites davidbenites ~/.ssh/id_ed25519
-rw-r--r-- 644 davidbenites davidbenites ~/.ssh/id_ed25519.pub

Interpretación:

id_ed25519
→ PRIVADA
→ 600
→ solo owner read/write

id_ed25519.pub
→ PÚBLICA
→ 644

La clave privada nunca debe copiarse a servidores.

---

## GitHub SSH

Se probó:

ssh -vT git@github.com

Se confirmó:

Authenticated to github.com (...) using "publickey".

Mensaje GitHub:

Hi allposibilities! You've successfully authenticated, but GitHub does not provide shell access.

Concepto:

GitHub utiliza usuario SSH `git`, pero identifica la cuenta mediante la clave pública.

---

## ssh-agent

Inicialmente:

echo $SSH_AUTH_SOCK

vacío.

Después:

ssh-add -l

Resultado:

Could not open a connection to your authentication agent.

Se aprendió a iniciar agente:

eval "$(ssh-agent -s)"

IMPORTANTE:

En un momento se ejecutó:

echo "$(ssh-agent -s)"

Eso solamente imprimió las variables.

La forma correcta para incorporar las variables al entorno actual es:

eval "$(ssh-agent -s)"

Después:

ssh-add ~/.ssh/id_ed25519

IMPORTANTE:

`ssh-add ~/.ssh/id_ed25519`

carga la CLAVE PRIVADA en ssh-agent.

NO carga la pública.

Modelo:

id_ed25519
→ privada
→ ssh-agent

id_ed25519.pub
→ pública
→ servidores / authorized_keys

Después de cargarla, SSH dejó de solicitar passphrase durante esa sesión.

---

# 9. CREACIÓN DE OLYMPUS-NODE01

Se creó VM VMware Workstation.

Configuración:

Ubuntu Server 22.04.5 LTS
RAM 2 GB
CPU 2
Disk 20 GB
NAT

Hostname:

olympus-node01

Usuario:

olympus

Se verificó:

whoami
→ olympus

hostname
→ olympus-node01

hostnamectl

Resultado incluía:

Operating System: Ubuntu 22.04.5 LTS
Virtualization: vmware
Architecture: x86-64

---

## Red

IP VM:

192.168.81.135

Desde WSL:

ping -c 4 192.168.81.135

Resultado:

0% packet loss

Después:

nc -vz 192.168.81.135 22

Resultado:

Connection ... port 22 [tcp/ssh] succeeded!

Conceptos:

ping
→ conectividad IP mediante ICMP

nc TCP/22
→ comprobar que puerto SSH es alcanzable

---

## SSH hacia olympus-node01

Conexión:

ssh olympus@192.168.81.135

Se configuró acceso por clave pública usando:

ssh-copy-id olympus@192.168.81.135

Resultado:

Number of key(s) added: 1

En servidor:

ls -ld ~/.ssh
ls -l ~/.ssh/authorized_keys
wc -l ~/.ssh/authorized_keys

Resultado:

drwx------ ... /home/olympus/.ssh
-rw------- ... /home/olympus/.ssh/authorized_keys
1 /home/olympus/.ssh/authorized_keys

Interpretación:

~/.ssh = 700
authorized_keys = 600
authorized_keys contiene una clave pública autorizada.

Modelo:

WSL:
~/.ssh/id_ed25519        PRIVATE

VM:
~/.ssh/authorized_keys
    └── public key

Se comprobó finalmente:

ssh -v olympus@192.168.81.135

Resultado clave:

Authenticated to 192.168.81.135 ([192.168.81.135]:22) using "publickey".

DÍA 5 COMPLETADO.

---

# 10. CONCEPTOS SSH QUE DEBEN CONSERVARSE

known_hosts:

CLIENTE verifica identidad del SERVIDOR.

authorized_keys:

SERVIDOR define qué claves públicas están autorizadas para autenticar usuarios.

id_ed25519:

clave privada local.

id_ed25519.pub:

clave pública.

passphrase:

protege la clave privada local.

password de olympus:

contraseña de la cuenta Linux remota.

ssh-agent:

mantiene/utiliza claves privadas desbloqueadas para evitar introducir repetidamente passphrase.

ssh:

cliente.

sshd:

daemon servidor.

TCP 22:

puerto SSH predeterminado.

ssh-agent NO reemplaza SSH.

SSH sigue siendo el transporte.

ssh-agent ayuda al cliente SSH con la clave privada.

---

# 11. DÍA 6 — ANSIBLE

Día 6 completado.

Objetivo:

Transformar el acceso SSH manual en administración automatizada.

---

# 12. INSTALACIÓN ANSIBLE

Inicialmente:

ansible --version

Resultado:

Command 'ansible' not found

Se instaló:

sudo apt update
sudo apt install ansible-core

IMPORTANTE:

Ansible se instaló SOLO en WSL.

NO se instaló Ansible en olympus-node01.

Esto demuestra la arquitectura agentless.

Verificación:

which ansible

Resultado:

/usr/bin/ansible

Python WSL:

python3 --version

Resultado:

Python 3.14.4

Ansible:

ansible --version

Resultado:

ansible [core 2.20.1]

config file = None

configured module search path:
~/.ansible/plugins/modules
/usr/share/ansible/plugins/modules

ansible python module location:
/usr/lib/python3/dist-packages/ansible

executable location:
/usr/bin/ansible

python version:
3.14.4

jinja:
3.1.6

pyyaml:
6.0.3

---

# 13. CONTROL NODE VS MANAGED NODE

CONTROL NODE:

WSL2 Ubuntu
usuario davidbenites
Ansible core 2.20.1
Python 3.14.4

MANAGED NODE:

olympus-node01
192.168.81.135
usuario olympus
Python 3.10
NO tiene Ansible instalado.

Modelo:

WSL
Ansible
│
│ SSH
▼
olympus-node01
│
└── Python remoto ejecuta muchos módulos

Ansible es agentless porque no necesita un agente Ansible permanente en el managed node.

---

# 14. INVENTORY

Se creó:

ansible/inventory/hosts.ini

Contenido:

[linux]
olympus-node01 ansible_host=192.168.81.135 ansible_user=olympus

Interpretación:

[linux]
→ grupo lógico Ansible

olympus-node01
→ alias/nombre del host dentro del inventory

ansible_host=192.168.81.135
→ dirección real a la cual conectar

ansible_user=olympus
→ usuario SSH remoto

Se verificó:

ansible-inventory -i ansible/inventory/hosts.ini --graph

Resultado:

@all:
  |--@ungrouped:
  |--@linux:
  |  |--olympus-node01

---

# 15. PRIMER ANSIBLE PING

Comando:

ansible linux \
-i ansible/inventory/hosts.ini \
-m ansible.builtin.ping

Resultado:

olympus-node01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.10"
    },
    "changed": false,
    "ping": "pong"
}

Warning:

Ansible descubrió automáticamente:

/usr/bin/python3.10

en el managed node.

Esto NO era error.

---

## ICMP ping vs Ansible ping

ping 192.168.81.135

comprueba principalmente conectividad IP/ICMP.

ansible.builtin.ping

comprueba aproximadamente:

inventory
→ host
→ SSH
→ autenticación
→ capacidad de ejecutar módulo remoto
→ Python remoto
→ respuesta

Por tanto puede existir:

ICMP ping OK
Ansible ping FAIL

si, por ejemplo, SSH TCP/22 falla.

---

# 16. PYTHON CONTROL VS REMOTO

WSL:

Python 3.14.4

Ejecuta Ansible y lógica del control node.

olympus-node01:

Python 3.10

Es utilizado para ejecutar muchos módulos remotos.

No necesitan tener exactamente la misma versión.

El Python remoto SÍ importa.

Warning actual:

Ansible está usando interpreter discovery.

Todavía NO se fijó explícitamente:

ansible_python_interpreter=/usr/bin/python3

Eso puede tratarse posteriormente.

---

# 17. COMANDOS AD-HOC

Se utilizaron:

ansible.builtin.command

Ejemplos:

ansible linux -i ansible/inventory/hosts.ini \
-m ansible.builtin.command \
-a "hostname"

Resultado:

olympus-node01 | CHANGED | rc=0 >>
olympus-node01

También:

-a "whoami"

Resultado:

olympus

También:

-a "uptime"

Resultado aproximado:

01:20:02 up 14 min, 1 user, load average...

Concepto:

rc=0
→ return code 0
→ éxito Unix/Linux.

IMPORTANTE:

command devolvió CHANGED aunque hostname/whoami/uptime no modificaron realmente el servidor.

Motivo:

ansible.builtin.command ejecuta comandos arbitrarios y no necesariamente conoce su semántica/estado.

---

# 18. ESTADO DESEADO E IDEMPOTENCIA

Concepto central aprendido:

Imperativo:

"Ejecuta este comando."

Declarativo:

"Quiero que el sistema quede en este estado."

Modelo:

ACTUAL != DESEADO
→ Ansible modifica
→ changed=true

ACTUAL == DESEADO
→ Ansible no modifica
→ changed=false

Eso representa idempotencia.

---

# 19. PRUEBA CON FILE

Primero:

ansible linux -i ansible/inventory/hosts.ini \
-m ansible.builtin.file \
-a "path=/home/olympus/olympus-test.txt state=touch"

Resultado primera vez:

CHANGED

Segunda vez:

también CHANGED.

Motivo:

state=touch actualiza timestamps.

Por tanto no era el ejemplo ideal de idempotencia estable.

Salida mostró:

owner=olympus
group=olympus
uid=1000
gid=1000
mode=0664
size=0

Se relacionó:

0664
→ rw-rw-r--

---

## state=absent

Se ejecutó:

ansible linux -i ansible/inventory/hosts.ini \
-m ansible.builtin.file \
-a "path=/home/olympus/olympus-test.txt state=absent"

Primera vez:

CHANGED
changed=true

Segunda vez:

SUCCESS
changed=false

Demostración de idempotencia.

---

## Directorio

Se ejecutó:

ansible linux -i ansible/inventory/hosts.ini \
-m ansible.builtin.file \
-a "path=/home/olympus/olympus-lab state=directory mode=0755"

Primera ejecución:

CHANGED
changed=true

Segunda:

SUCCESS
changed=false

Resultado:

owner olympus
group olympus
mode 0755
state directory

Interpretación:

0755
owner → rwx
group → r-x
others → r-x

---

# 20. PRIVILEGE ESCALATION — BECOME

Se intentó instalar Nginx sin privilegios:

ansible linux \
-i ansible/inventory/hosts.ini \
-m ansible.builtin.apt \
-a "name=nginx state=present update_cache=yes"

Falló.

Error relevante:

Could not open lock file /var/lib/apt/lists/lock
Permission denied

Motivo:

Ansible conectó como:

olympus

Ese usuario sin elevación no podía modificar paquetes del sistema.

---

## Become

Se utilizó:

-b

equivale a:

--become

Solicita ejecutar la tarea elevando privilegios, normalmente mediante sudo.

También:

-K

equivale a:

--ask-become-pass

Pregunta la contraseña necesaria para la elevación.

CORRECCIÓN IMPORTANTE APRENDIDA:

-K NO significa necesariamente "password de root".

En este laboratorio:

BECOME password
=
password de olympus utilizada por sudo.

Flujo:

WSL
│
│ SSH publickey
▼
olympus
│
│ sudo / become
│ password de olympus
▼
root
│
▼
operación administrativa

Ansible NO conecta directamente como root.

---

# 21. TRES CREDENCIALES DIFERENTES

1. Password de olympus

Contraseña de la cuenta Linux `olympus`.

Puede utilizarse para autenticación SSH por password y, dado sudo configurado, para sudo.

2. Passphrase de id_ed25519

Protege la clave PRIVADA local.

No se envía al servidor.

ssh-agent puede mantener la clave desbloqueada en memoria.

3. BECOME password

Contraseña solicitada para la elevación.

En este laboratorio corresponde a la contraseña de olympus para sudo.

No confundir estas tres funciones.

---

# 22. INSTALACIÓN NGINX CON ANSIBLE

Comando exitoso:

ansible linux \
-i ansible/inventory/hosts.ini \
-b \
-K \
-m ansible.builtin.apt \
-a "name=nginx state=present update_cache=yes"

Resultado:

CHANGED

Se instaló Nginx y dependencias.

APT resolvió automáticamente dependencias.

También se observó integración con systemd.

Se creó symlink relacionado con:

multi-user.target.wants/nginx.service

Se comprendió diferencia entre:

started
→ servicio corriendo actualmente

enabled
→ servicio configurado para iniciar durante boot.

---

# 23. PRIMER PLAYBOOK

Se creó:

ansible/playbooks/nginx.yml

Contenido:

---
- name: Configure Nginx web server
  hosts: linux
  become: true

  tasks:
    - name: Ensure Nginx is installed
      ansible.builtin.apt:
        name: nginx
        state: present
        update_cache: true

    - name: Ensure Nginx is enable and running
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true

NOTA:

El nombre de la segunda task quedó escrito:

"Ensure Nginx is enable and running"

Podría corregirse estilísticamente a:

"Ensure Nginx is enabled and running"

La funcionalidad no se ve afectada porque `name` es descripción.

---

# 24. ESTRUCTURA PLAYBOOK

Se aprendió:

---
→ inicio documento YAML

- name:
→ un play dentro de una lista

hosts: linux
→ grupo objetivo del inventory

become: true
→ equivalente conceptual a -b

tasks:
→ lista de tareas

ansible.builtin.apt
→ módulo para administrar paquetes APT

name: nginx
state: present
→ nginx debe existir/estar instalado

update_cache: true
→ actualizar cache de paquetes

ansible.builtin.service
→ módulo de servicios

state: started
→ debe estar corriendo

enabled: true
→ debe iniciar automáticamente con sistema.

---

# 25. PLAYBOOK CHECK MODE

Se ejecutó:

ansible-playbook \
-i ansible/inventory/hosts.ini \
ansible/playbooks/nginx.yml \
-K \
--check

Resultado:

PLAY [Configure Nginx web server]

TASK [Gathering Facts]
ok

TASK [Ensure Nginx is installed]
ok

TASK [Ensure Nginx is enable and running]
ok

PLAY RECAP:

olympus-node01:
ok=3
changed=0
unreachable=0
failed=0

Concepto:

--check
→ check mode
→ intenta predecir qué cambiaría sin aplicar normalmente los cambios.

No todos los módulos pueden simular perfectamente todas las operaciones.

---

# 26. GATHERING FACTS

El playbook agregó automáticamente:

TASK [Gathering Facts]

Esto ocurre por defecto.

Ansible obtiene información del managed node como:

- sistema operativo
- hostname
- interfaces
- arquitectura
- Python
- etc.

Todavía no se profundizó en `ansible_facts`.

Es buen tema para Día 7.

---

# 27. EJECUCIÓN REAL PLAYBOOK

Hubo inicialmente un typo:

ansible-playbooks

Resultado:

Command 'ansible-playbooks' not found

Se corrigió a:

ansible-playbook

IMPORTANTE:

El ejecutable correcto es singular:

ansible-playbook

Se ejecutó:

ansible-playbook \
-i ansible/inventory/hosts.ini \
ansible/playbooks/nginx.yml \
-K

Resultado:

Gathering Facts → ok
Ensure Nginx is installed → ok
Ensure Nginx is enable and running → ok

RECAP:

ok=3
changed=0
unreachable=0
failed=0

Se ejecutó una SEGUNDA vez.

Mismo resultado:

ok=3
changed=0
failed=0

Esto demuestra idempotencia del playbook con el estado actual.

---

# 28. AD-HOC VS PLAYBOOK

Se comprendió:

AD-HOC:

ansible ... -m ... -a ...

Sirve para acciones puntuales/pruebas/administración inmediata.

PLAYBOOK:

archivo YAML versionable.

Permite describir automatización reproducible.

Evolución conceptual:

comandos manuales
↓
SSH
↓
Ansible ad-hoc
↓
módulos especializados
↓
estado deseado
↓
idempotencia
↓
playbooks
↓
Infrastructure as Code
↓
Git

---

# 29. GIT AL FINAL DEL DÍA 6

Se ejecutó:

git status

Resultado:

On branch main
Your branch is up to date with 'origin/main'.

Changes to be committed:

modified:
README.md

Untracked:

ansible/inventory/
ansible/playbooks/

Se ejecutó:

git diff

y no mostró nada.

Se explicó por qué:

git diff
→ Working Directory vs Staging Area

README.md ya estaba staged.

Para revisar staged:

git diff --cached

o:

git diff --staged

Modelo Git recordado:

Working Directory
↓ git add
Staging Area
↓ git commit
Repository

Se indicó revisar:

git diff --cached

find ansible -maxdepth 3 -type f -print

cat ansible/inventory/hosts.ini
cat ansible/playbooks/nginx.yml

Luego:

git add ansible/inventory/hosts.ini ansible/playbooks/nginx.yml

git status

git diff --cached

Antes de commit verificar que NO existan:

- passwords
- private keys
- passphrases
- secretos

Commit propuesto:

git commit -m "feat: add first Ansible inventory and Nginx playbook"

Luego:

git log --oneline -3

git push

EL USUARIO INDICÓ QUE COMPLETÓ ESTE CIERRE.

Por tanto considerar DÍA 6 COMPLETADO.

---

# 30. CHECKPOINT CONCEPTUAL DÍA 6

El usuario respondió un cuestionario.

Nivel aproximado:

8.5/10

Conceptos que comprendió correctamente:

- Ansible se ejecuta desde WSL.
- Managed node no necesita Ansible.
- SSH es transporte.
- Inventory agrupa hosts.
- ansible_host indica destino real.
- ansible_user indica usuario remoto.
- ICMP ping y Ansible ping prueban cosas diferentes.
- Idempotencia.
- Estado actual vs estado deseado.
- command no conoce necesariamente el estado.
- módulos especializados modelan recursos.
- apt requiere privilegios administrativos.
- become eleva privilegios.
- la clave privada nunca se pasa al servidor.
- grupos permiten administrar múltiples servidores.
- declarativo evita modificaciones innecesarias.

Correcciones importantes realizadas:

1. ssh-agent NO es el transporte.

SSH sigue siendo el transporte.

ssh-agent ayuda a SSH a utilizar la clave privada.

2. -K NO significa password de root.

Solicita become password.

En Olympus:

password de olympus
→ sudo
→ root.

3. Python remoto sí importa.

WSL Python:
ejecuta Ansible/control.

VM Python:
ejecuta muchos módulos remotos.

4. Ventaja de `state=present` no es solo ejecutar sobre un grupo.

También:

cada servidor se lleva al estado deseado individualmente.

Ejemplo:

node01 nginx no instalado
→ instala
→ changed=true

node02 nginx instalado
→ no cambia
→ changed=false

node03 nginx no instalado
→ instala
→ changed=true

---

# 31. ESTADO EXACTO AL TERMINAR DÍA 6

CONTROL NODE:

WSL2 Ubuntu

Usuario:

davidbenites

Repositorio:

~/Projects/project-olympus

Ansible:

ansible-core 2.20.1

Python:

3.14.4

SSH:

operativo mediante publickey.

ssh-agent:

se ha utilizado para mantener clave privada desbloqueada.

---

MANAGED NODE:

Hostname:

olympus-node01

IP:

192.168.81.135

OS:

Ubuntu Server 22.04.5 LTS

Usuario:

olympus

Python:

/usr/bin/python3.10

SSH:

TCP/22 operativo

Autenticación:

publickey

Ansible instalado en VM:

NO.

Nginx:

instalado.

Servicio:

running.

Servicio habilitado:

enabled.

Directorio de laboratorio creado:

/home/olympus/olympus-lab

mode:

0755

---

# 32. ARCHIVOS ANSIBLE ACTUALES

project-olympus/
└── ansible/
    ├── inventory/
    │   └── hosts.ini
    │
    └── playbooks/
        └── nginx.yml

Inventory:

[linux]
olympus-node01 ansible_host=192.168.81.135 ansible_user=olympus

Playbook:

---
- name: Configure Nginx web server
  hosts: linux
  become: true

  tasks:
    - name: Ensure Nginx is installed
      ansible.builtin.apt:
        name: nginx
        state: present
        update_cache: true

    - name: Ensure Nginx is enable and running
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true

---

# 33. WARNING ACTUAL PENDIENTE

Cada ejecución Ansible muestra:

Host 'olympus-node01' is using the discovered Python interpreter at '/usr/bin/python3.10', but future installation of another Python interpreter could cause a different interpreter to be discovered.

No es un error.

Todavía no se ha decidido/fijado:

ansible_python_interpreter=/usr/bin/python3

Este tema puede abordarse posteriormente explicando primero interpreter discovery.

---

# 34. CONFIGURACIÓN ANSIBLE PENDIENTE

`ansible --version` mostró:

config file = None

Todavía NO existe/configuramos un:

ansible.cfg

dentro de Project Olympus.

Esto es un siguiente paso natural.

El objetivo sería dejar de repetir:

-i ansible/inventory/hosts.ini

configurando inventory por defecto.

Pero debe enseñarse explicando:

- precedence/configuración Ansible;
- qué es ansible.cfg;
- por qué se utiliza;
- dónde busca Ansible configuración.

No simplemente crear el archivo.

---

# 35. DÍA 7 — PUNTO DE PARTIDA RECOMENDADO

NO repetir Días 1–6.

Empezar diciendo aproximadamente:

"Project Olympus — Día 7"

Primero comprobar rápidamente estado:

cd ~/Projects/project-olympus

git status

ansible --version

Opcional:

ansible linux -i ansible/inventory/hosts.ini -m ansible.builtin.ping

Después continuar con una progresión lógica.

Temas naturales para Día 7:

1. ansible.cfg
2. Ansible configuration precedence
3. inventory mejor estructurado
4. ansible_facts
5. variables
6. variables de grupo/host
7. módulos declarativos adicionales
8. handlers
9. templates
10. primer playbook algo más real de configuración web

NO intentar cubrirlos todos superficialmente.

Mantener profundidad y aprendizaje progresivo.

---

# 36. POSIBLE OBJETIVO DÍA 7

Una buena meta:

Convertir la configuración actual de Nginx en una automatización más limpia y profesional.

Posible evolución:

project-olympus/
└── ansible/
    ├── ansible.cfg
    ├── inventory/
    │   ├── hosts.ini
    │   └── group_vars/
    └── playbooks/
        └── nginx.yml

Aprender:

- configuración por defecto;
- facts;
- variables;
- copy/template;
- handlers;
- notify;
- restart/reload solo cuando configuración cambia;
- idempotencia.

Ejemplo conceptual futuro:

template cambia nginx.conf
        │
        ├── changed=false
        │       ↓
        │    no reload
        │
        └── changed=true
                ↓
             notify
                ↓
             handler
                ↓
          reload nginx

Esto permite demostrar por qué handlers son importantes:

Nginx solo se recarga si la configuración realmente cambió.

---

# 37. ROADMAP POSTERIOR — NO ADELANTAR SIN NECESIDAD

Una ruta posible después:

Día 7+
Ansible configuration/facts/variables/handlers/templates

Después:
segundo managed node

Objetivo:

[linux]
olympus-node01
olympus-node02

Esto permitirá comprobar realmente:

- grupos;
- paralelismo;
- idempotencia por host;
- diferencias de estado;
- variables.

Posteriormente:

roles Ansible

Estructura:

roles/
└── nginx/
    ├── tasks/
    ├── handlers/
    ├── templates/
    ├── defaults/
    └── vars/

Después:

Ansible Vault

Para secretos.

Después:

AWX

Para llevar la automatización Ansible hacia:

- UI
- inventories
- credentials
- projects
- job templates
- RBAC
- schedules

Después:

Docker

Después:

Terraform

Terraform:
provisionamiento infraestructura.

Ansible:
configuración del sistema.

Concepto futuro:

Terraform
↓
crea infraestructura
↓
Ansible
↓
configura infraestructura
↓
observabilidad/hardening
↓
automatización completa

No correr hacia estas herramientas sin dominar fundamentos.

---

# 38. METODOLOGÍA QUE EL USUARIO PREFIERE

MUY IMPORTANTE.

El usuario NO quiere simplemente:

"Ejecuta estos 20 comandos."

Prefiere:

comando
↓
explicación literal
↓
qué componente actúa
↓
qué ocurre internamente
↓
ejecución
↓
observar salida
↓
interpretarla
↓
preguntas/checkpoint
↓
siguiente concepto

Cuando haya errores:

NO ocultarlos.

Usarlos para aprender troubleshooting.

Ejemplo exitoso del Día 6:

apt sin become
→ permission denied
→ entender permisos
→ introducir become
→ volver a ejecutar
→ éxito.

Esta metodología debe mantenerse.

---

# 39. FILOSOFÍA DEL PROYECTO

El usuario busca que el camino sea parte central del aprendizaje.

No quiere solamente "terminar Ansible".

Quiere integrar progresivamente:

Linux
+
redes
+
Git
+
SSH
+
Ansible
+
Docker
+
Cloud
+
observabilidad
+
seguridad
+
automatización

hasta poder comprender sistemas completos.

Cada herramienta debe conectarse con conocimientos anteriores.

Ejemplos ya realizados:

Linux permissions
→ SSH key permissions
→ Ansible file modes

Linux processes
→ sshd
→ systemd
→ nginx

Networking
→ ICMP
→ TCP/22
→ SSH
→ Ansible

Git internals
→ versionar Infrastructure as Code

SSH
→ transporte de Ansible

sudo
→ Ansible become

Python
→ ejecución módulos Ansible.

---

# 40. ESTADO DE PROGRESO

Día 1: COMPLETADO
Día 2: COMPLETADO
Día 3: COMPLETADO
Día 4: COMPLETADO
Día 5: COMPLETADO
Día 6: COMPLETADO

SIGUIENTE:

DÍA 7.

Al iniciar un nuevo chat:

NO volver a explicar desde Día 1.

Leer este contexto y comenzar desde el estado actual.

Primero hacer una comprobación breve de continuidad y luego iniciar el Día 7.

# FIN DEL CONTEXTO