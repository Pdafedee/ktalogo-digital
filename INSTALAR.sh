#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
#  Ktalogo-Dgital v2.1.0 · INSTALADOR AUTOMATICO (Linux / macOS)
#  Uso:  bash INSTALAR.sh
#  Hace todo: proxy → Python → venv → dependencias → doctor → lanzador
# ═══════════════════════════════════════════════════════════════════
set -u
cd "$(dirname "$0")"

B="\033[1;36m"; G="\033[1;32m"; Y="\033[1;33m"; R="\033[1;31m"; N="\033[0m"
say() { printf "%b\n" "$1"; }

say "${B}============================================================"
say " Ktalogo-Dgital v2.1.0 · INSTALADOR AUTOMATICO (Linux/macOS)"
say "============================================================${N}"

# ── 0 · Proxy sin protocolo (Java/pip exigen http://) ───────────────
for var in HTTP_PROXY HTTPS_PROXY; do
  eval "v=\${$var:-}"
  if [ -z "$v" ]; then
    say "  ${G}[ok]${N} $var no esta definido"
  else
    case "$v" in
      *://*) say "  ${G}[ok]${N} $var ya tiene protocolo: $v" ;;
      *)     export "$var=http://$v"
             say "  ${Y}[i]${N} $var corregido -> http://$v (solo esta sesion)" ;;
    esac
  fi
done

# ── 1 · Python 3.10+ ────────────────────────────────────────────────
PY=""
for cand in python3.12 python3.11 python3.10 python3; do
  if command -v "$cand" >/dev/null 2>&1; then PY="$cand"; break; fi
done
if [ -z "$PY" ]; then
  say "${Y}[1/6]${N} Python no encontrado; intentando instalar..."
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -y && sudo apt-get install -y python3 python3-venv python3-pip
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y python3 python3-pip
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm python python-pip
  elif command -v zypper >/dev/null 2>&1; then
    sudo zypper install -y python3 python3-pip python3-venv
  elif command -v brew >/dev/null 2>&1; then
    brew install python@3.12
  else
    say "${R}[!]${N} No pude instalar Python automaticamente."
    say "    Instala Python 3.10+ con tu gestor de paquetes y reejecuta."
    exit 1
  fi
  PY=python3
fi
if ! "$PY" -c "import sys; sys.exit(0 if sys.version_info >= (3,10) else 1)"; then
  say "${R}[!]${N} Se requiere Python 3.10+ (encontrado: $("$PY" -V 2>&1))."
  exit 1
fi
say "${G}[1/6]${N} Python OK: $("$PY" -V 2>&1)"

# ── 2 · Entorno virtual ─────────────────────────────────────────────
say "${Y}[2/6]${N} Entorno virtual (.venv)..."
if ! "$PY" -m venv .venv 2>/dev/null; then
  say "  ${Y}[i]${N} Sin modulo venv (instala python3-venv); uso Python del sistema"
fi
if [ -x .venv/bin/python ]; then
  PIP=".venv/bin/python -m pip"
  DRUN=".venv/bin/python"
else
  PIP="$PY -m pip"
  DRUN="$PY"
fi

# ── 3 · Dependencias (con reintento sin proxy) ──────────────────────
say "${Y}[3/6]${N} Instalando dependencias (2-5 min segun conexion)..."
$PIP install --upgrade pip >/dev/null 2>&1 || true
if ! $PIP install -r requirements.txt; then
  say "  ${Y}[i]${N} Reintento sin proxy..."
  unset HTTP_PROXY HTTPS_PROXY
  if ! $PIP install -r requirements.txt; then
    say "${R}[!]${N} Fallo la instalacion de dependencias (internet/proxy)."
    exit 1
  fi
fi
say "  ${G}Dependencias instaladas.${N}"

# ── 4 · Doctor ──────────────────────────────────────────────────────
say "${Y}[4/6]${N} Verificando el sistema (Doctor)..."
$DRUN scripts/doctor.py || say "  ${Y}[i]${N} El Doctor mostro detalles; revisalos arriba."

# ── 5 · Lanzadores ejecutables ──────────────────────────────────────
say "${Y}[5/6]${N} Permisos de lanzadores..."
chmod +x INICIAR.sh INSTALAR.sh 2>/dev/null || true

# ── 6 · Informe final ───────────────────────────────────────────────
LAN_IP=$(hostname -I 2>/dev/null | awk '{print $1}')
[ -z "${LAN_IP:-}" ] && LAN_IP=$(ipconfig getifaddr en0 2>/dev/null || echo "TU-IP")
say ""
say "${G}[6/6]${N} ${B}INSTALACION COMPLETADA${N}"
say "${B}============================================================${N}"
say " COMO USAR Ktalogo-Dgital desde hoy:"
say ""
say " [PC - escritorio]      ./INICIAR.sh"
say " [CELULAR / TABLET /    ./INICIAR.sh --web"
say "  OTRO DISPOSITIVO]     y en el otro dispositivo abre:"
say "                        http://${LAN_IP}:8550  (misma red Wi-Fi)"
say " [ANDROID - app nativa] docs/GUIA_APK.md (APK compilado en la nube)"
say "${B}============================================================${N}"
printf "%b" "${N}"
read -r -p "Abrir la aplicacion ahora? [S/n]: " resp
case "$resp" in
  n|N|no|NO) say "Listo. Cuando quieras: ./INICIAR.sh" ;;
  *) if [ -x .venv/bin/python ]; then exec .venv/bin/python main.py; else exec "$PY" main.py; fi ;;
esac
