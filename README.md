# debouncer_fsm
Ejercicio de diseño y verificación de un debouncer

Descripción de la verificación del proyecto red IP

## Contenido

- [debouncer_fsm\_detector](#debouncer_fsm)
  - [Contenido](#contenido)
  - [Configuración de Git](#configuración-de-git)
  - [Generar una llave SSH](#generar-una-llave-ssh)
  - [Agregar la llave SSH a GitHub](#agregar-la-llave-ssh-a-github)
  - [Configurar SSH para GitHub](#configurar-ssh-para-github)
  - [Descarga del repositorio](#descarga-del-repositorio)
  - [Flujo de Git](#flujo-de-git)
  - [Incorporar cambios de `main` a una rama de característica](#incorporar-cambios-de-main-a-una-rama-de-característica)
  - [Herramientas](#herramientas)
    - [Vivado](#vivado)
    - [Manuales](#manuales)
  - [Contactos](#contactos)

## Configuración de Git

Verifica que la versión de tu instalación de Git sea > 1.8 con:

```bash
git --version
```

La primera vez que uses `git` necesitas configurar:

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu.correo@ejemplo.com"
```

Puedes revisar tu configuración en cualquier momento con:

```bash
git config --list
```

## Generar una llave SSH

Puedes interactuar con GitHub usando **HTTPS** o **SSH**. El protocolo **recomendado** es SSH,
porque utiliza un par de **llaves privada/pública** y no requiere autenticación por contraseña.

Para usar SSH primero necesitas [generar un nuevo par de llaves SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key) con:

```bash
cd ~/.ssh
ssh-keygen -t ed25519 -C "tu_correo@ejemplo.com"
```

- Si el directorio `~/.ssh` no existe aún, créalo con:

  ```bash
  mkdir ~/.ssh
  ```

- Cuando se te pida el nombre del archivo, usa un nombre descriptivo como `id_ed25519_github`.
- Ingresa una frase de contraseña cuando se te solicite (recomendado por seguridad).

## Agregar la llave SSH a GitHub

A continuación, agrega tu **llave pública** SSH a tu cuenta de GitHub.

Muestra la llave pública con:

```bash
cat id_ed25519_github.pub
```

Luego:

- Haz clic en tu foto de perfil de GitHub.
- Navega a **Settings > SSH and GPG keys > New SSH Key**. Consulta tus [llaves SSH](https://github.com/settings/keys).
- Crea una nueva entrada de llave y pega el contenido de la llave pública.

## Configurar SSH para GitHub

Finalmente, crea (o edita) el archivo `~/.ssh/config` para indicarle a SSH qué llave usar para GitHub:

```bash
# Cuenta de GitHub
Host github.com
  HostName github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_ed25519_github
```

## Descarga del repositorio

Descarga el repositorio usando:

```bash
cd /ruta/a/tu/area/de/trabajo
git clone git@github.com:uvm-collab/spi_ip.git
```

Cuando se te solicite autenticación, ingresa la frase de contraseña de la llave SSH elegida para completar la descarga.

## Flujo de Git

Usa [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) de Git

1. Crear rama

```bash
git switch -c feat/uvc-monitor-logic
# o
git branch feat/uvc-monitor-logic && git switch feat/uvc-monitor-logic
```

2. Trabajar, agregar, hacer commit (commits pequeños, Conventional Commits)

```bash
git add monitor.sv
git commit -m "feat: add monitor logic"
```

3. Subir tu rama a GitHub

```bash
git push -u origin feat/uvm-monitor-logic
```

4. Abrir un **Pull Request** en GitHub.

   - Usa un título de PR claro siguiendo Conventional Commits
   - Agrega más commits según sea necesario

5. Fusionar el **Pull Request**

    - Usa la opción que elija tu equipo (Merge commits/Squash)
    - Haz clic en **Delete branch** en GitHub

6. Limpiar localmente y eliminar ramas remotas obsoletas

```bash
git switch main
git fetch --prune origin
git branch -D feat/uvm-monitor-logic
```

7. Sincronizar tu rama `main` local (solo fast-forward)

```bash
git pull --ff-only origin main
```

## Incorporar cambios de `main` a una rama de característica

Al trabajar en una rama de característica, frecuentemente necesitas actualizarla con los últimos
cambios de `main`. El enfoque recomendado es:

```bash
git switch feat/branch
git fetch origin main
git merge origin/main
# resolver conflictos si los hay, luego hacer commit
```

## Herramientas

### Vivado

- [Configuración del Entorno](docs/setup_env.md)

### Manuales

1. [Referencia principal de verificación - Simulación, SystemVerilog y Synopsys](https://uvmcollab.org)

> [!IMPORTANT]  
> Las referencias de Verificación son importantes

