# 🚀 Actualización 2.1.0 · «Instalador automático»

**Fecha:** 2026-11-04 · **Base:** v2.0.2 · **Tema:** instalación en 1 clic
desde PC, celular o cualquier otro dispositivo.

## Problema que resuelve

Hasta ahora instalar el proyecto exigía pasos manuales (Python, pip,
proxy, Terminal…). Con la v2.1.0 el propio proyecto se instala solo:
cada dispositivo tiene un instalador que detecta el entorno, corrige el
proxy defectuoso (caso `127.0.0.1:34253` sin `http://`), instala todo y
deja la lista para arrancar.

## Rutas de instalación incluidas

| Dispositivo | Instalador | Resultado |
|---|---|---|
| PC Windows | `INSTALAR.bat` | App escritorio + web + accesos directos en Escritorio |
| PC Linux / macOS | `INSTALAR.sh` | App escritorio + web |
| Android · app nativa | APK en la nube (GitHub Actions, ahora también en **Releases**) | `Ktalogo-Dgital.apk` |
| Android · sin APK | `INSTALAR-TERMUX.sh` (Termux) | Servidor web en el propio celular |
| iPhone / tablet / otro PC | `INICIAR-WEB.bat` en el PC principal | App completa por navegador: escanea el **QR** o entra a `http://IP:8550` |

## Archivos nuevos (8)

| Archivo | Función |
|---|---|
| `INSTALAR.bat` | Instalador maestro Windows: corrige proxy sin `http://`, detecta/instala Python (winget), crea `.venv`, instala dependencias con reintento sin proxy, corre el Doctor y crea accesos directos |
| `INICIAR.bat` | Lanzador diario Windows (usa `.venv` si existe; limpia cachés; doctor previo) |
| `INICIAR-WEB.bat` | Lanzador del servidor web: imprime las IPv4 del PC, genera y abre un **QR** para el celular; servidor escuchando en toda la red (`0.0.0.0`); puerto configurable (`INICIAR-WEB.bat 9000`) |
| `INSTALAR.sh` | Instalador maestro Linux/macOS (apt/dnf/pacman/zypper/brew, venv, deps, doctor, IP local) |
| `INICIAR.sh` | Lanzador diario Linux/macOS (`--web` opcional) |
| `INSTALAR-TERMUX.sh` | Instalador Android/Termux: paquetes base, Pillow/lxml precompilados, núcleo flet, flet-web con reintento uvicorn puro, extras PDF/DOC tolerantes, doctor lite y arranque `--web` |
| `app/netinfo.py` | Detección de IP LAN + generación de **QR de acceso** (`data/web_qr.png`) para entrar desde el celular con la cámara, sin escribir direcciones |
| `docs/INSTALACION.md` | Guía maestra multiplataforma (5 rutas + proxy/VPN + tabla de problemas) |

## Archivos actualizados (7)

| Archivo | Cambio |
|---|---|
| `requirements.txt` | `flet[desktop,web]==1.0.5`: instala de una vez escritorio **y** navegador; evita el auto-instalado en el primer arranque (que falla tras un proxy roto) |
| `main.py` | `--web` ahora escucha en `0.0.0.0` (el celular YA puede entrar; antes quedaba en `127.0.0.1`), imprime IPs + QR, y acepta `--host` para restringir |
| `app/config.py` | `VERSION = "2.1.0"` |
| `scripts/doctor.py` | Modo **lite** (`--lite` o detección automática de Termux): reportlab/docx/Pillow pasan a opcionales con aviso; umbral de versión antigua → 2.1.0 |
| `.github/workflows/build-apk.yml` | Publica el APK en **Releases** al etiquetar `v*` (enlace permanente para el celular) |
| `pyproject.toml` | `version = "2.1.0"` |
| `README.md` | Nueva sección 1: instalación automática por dispositivo |
| `docs/GUIA_APK.md` | (sin cambios: ya contenía la solución de proxy de v2.0.2) |

## Garantías que se mantienen

- El cargador `.env` tolerante y los conversores numéricos blindados de
  v2.0.x no se tocaron: un `.env` mal escrito **no puede** romper el arranque.
- Los instaladores nunca tocan `data/` (tus ventas, saldo y blockchain).
- El instalador es idempotente: ejecutarlo de nuevo **actualiza o
  repara** sin borrar nada.
- En Android (APK o Termux) las exportaciones sin reportlab/python-docx
  caen automáticamente a TXT (degradación elegante v2.0).

## Cómo actualizar desde v2.0.x

1. Descomprime el paquete **ENCIMA** de tu carpeta actual
   (sobrescribe: los archivos están en la raíz del zip).
2. Doble clic en `INSTALAR.bat` (Windows) o `bash INSTALAR.sh`.
3. Verifica el sello: la consola muestra `v2.1.0` y el Doctor reporta
   «TODO EN ORDEN».
