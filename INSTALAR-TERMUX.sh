#!/data/data/com.termux/files/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
#  Ktalogo-Dgital v2.1.0 · INSTALADOR AUTOMATICO para ANDROID (Termux)
#
#  Qué hace: instala Python y la app EN TU CELULAR, y la deja corriendo
#  como servidor web. Luego abres http://localhost:8550 en el navegador
#  del mismo celular. Sin PC, sin APK, sin GitHub.
#
#  Requisito único: la app Termux (instálala de F-Droid o GitHub, NO de
#  Play Store — la de Play Store está obsoleta):
#    https://f-droid.org/es/packages/com.termux/
#  Después, copia esta carpeta al celular y ejecuta:
#    bash INSTALAR-TERMUX.sh
# ═══════════════════════════════════════════════════════════════════
set -u
cd "$(dirname "$0")"

B="\033[1;36m"; G="\033[1;32m"; Y="\033[1;33m"; R="\033[1;31m"; N="\033[0m"
say() { printf "%b\n" "$1"; }

say "${B}============================================================"
say " Ktalogo-Dgital v2.1.0 · INSTALADOR ANDROID (Termux)"
say "============================================================${N}"

if ! command -v pkg >/dev/null 2>&1; then
  say "${R}[!]${N} Este script es para la app Termux de Android."
  say "    · Celular → instalación NATIVA (APK):  docs/GUIA_APK.md"
  say "    · Sin instalar nada en el celular:     INICIAR-WEB.bat en tu PC"
  exit 1
fi

# ── 0 · Proxy sin protocolo ─────────────────────────────────────────
for var in HTTP_PROXY HTTPS_PROXY; do
  eval "v=\${$var:-}"
  if [ -n "$v" ]; then
    case "$v" in
      *://*) : ;;
      *)     export "$var=http://$v"; say "  ${Y}[i]${N} $var corregido -> http://$v" ;;
    esac
  fi
done

# ── 1 · Paquetes base de Termux ─────────────────────────────────────
say "${Y}[1/5]${N} Instalando paquetes base (2-6 min la primera vez)..."
yes | pkg update -y >/dev/null 2>&1 || true
pkg install -y python python-pip clang make pkg-config libffi openssl >/dev/null 2>&1 \
  || say "  ${Y}[i]${N} Algún paquete base falló; continúo con lo disponible"
# Librerías PRECOMPILADAS de Termux (evitan compilaciones largas)
pkg install -y python-pillow python-lxml >/dev/null 2>&1 \
  && say "  ${G}[ok]${N} Pillow y lxml precompilados (imágenes y DOC activos)" \
  || say "  ${Y}[i]${N} Pillow/lxml por pkg no disponible; se intentará por pip"
command -v python >/dev/null 2>&1 || { say "${R}[!]${N} Python no quedó instalado."; exit 1; }
say "  ${G}[ok]${N} Python $(python -V 2>&1)"

# ── 2 · pip al día ──────────────────────────────────────────────────
say "${Y}[2/5]${N} Preparando pip..."
pip install --upgrade pip wheel setuptools >/dev/null 2>&1 || true

# ── 3 · Dependencias (núcleo imprescindible, extras tolerantes) ─────
say "${Y}[3/5]${N} Instalando núcleo de la app..."
FALTAN=""
for paq in "flet==1.0.5" "flet-charts>=1.0.0" "segno>=1.6.6" "requests>=2.31"; do
  if pip install "$paq" >/dev/null 2>&1; then
    say "  ${G}[ok]${N} $paq"
  else
    FALTAN="$FALTAN $paq"
    say "  ${R}[!]${N} $paq"
  fi
done
if [ -n "$FALTAN" ]; then
  say "${R}[!]${N} Faltan dependencias del núcleo:$FALTAN"
  say "    Revisa tu internet y vuelve a ejecutar este script."
  exit 1
fi

say "  Instalando servidor web (flet-web; puede compilar 5-15 min)..."
if pip install "flet-web==1.0.5"; then
  say "  ${G}[ok]${N} flet-web (modo navegador listo)"
else
  say "  ${Y}[i]${N} flet-web falló; reintento solo con uvicorn puro..."
  pip install uvicorn fastapi websockets >/dev/null 2>&1 || true
  pip install "flet-web==1.0.5" || say "  ${R}[!]${N} flet-web no instaló; usa la ruta APK (docs/GUIA_APK.md)"
fi

say "  Extras opcionales (PDF/DOC — si fallan, la app exporta en TXT):"
pip install "reportlab>=4.0" >/dev/null 2>&1 && say "  ${G}[ok]${N} PDF" || say "  ${Y}[i]${N} PDF no disponible (se exporta en TXT)"
pip install "python-docx>=1.1" >/dev/null 2>&1 && say "  ${G}[ok]${N} DOC" || say "  ${Y}[i]${N} DOC no disponible (se exporta en TXT)"

# ── 4 · Doctor en modo lite (Termux detectado automáticamente) ──────
say "${Y}[4/5]${N} Verificando el sistema (Doctor lite)..."
python scripts/doctor.py --lite || true

# ── 5 · Arrancar ────────────────────────────────────────────────────
say ""
say "${G}[5/5]${N} ${B}INSTALACIÓN COMPLETADA${N}"
say "${B}============================================================${N}"
say "  La app servirá en:  ${G}http://localhost:8550${N}"
say "  Ábrela en el navegador de ESTE celular (Chrome/Firefox)."
say "  Para volver a abrirla otro día, en Termux ejecuta:"
say "      cd $(pwd) && python main.py --web --port 8550"
say "  Consejo: activa wakelock en Termux para que no se apague"
say "  el servidor con la pantalla bloqueada:  termux-wake-lock"
say "${B}============================================================${N}"
python main.py --web --port 8550
