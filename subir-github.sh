#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════
#  Ktalogo-Dgital · Subir y sincronizar con GitHub
#  Linux · macOS · Termux (Android)
#  Uso:  bash subir-github.sh          (1a vez y en cada actualización)
#        bash subir-github.sh "mi mensaje de cambio"
# ═══════════════════════════════════════════════════════════════════
set -u
cd "$(dirname "$0")"

azul='\033[1;36m'; verde='\033[1;32m'; rojo='\033[1;31m'; neutro='\033[0m'
echo -e "${azul}════════════════════════════════════════════════════════${neutro}"
echo -e "${azul} KTALOGO-DGITAL · SUBIR / SINCRONIZAR CON GITHUB${neutro}"
echo -e "${azul}════════════════════════════════════════════════════════${neutro}"

# ── 0 · Comprobar Git ────────────────────────────────────────────────
if ! command -v git >/dev/null 2>&1; then
    echo -e "${rojo}[X] Git no está instalado.${neutro}"
    echo "    Linux:      sudo apt install git"
    echo "    macOS:      xcode-select --install"
    echo "    Termux:     pkg install git"
    exit 1
fi
echo "[0/5] Git detectado: OK"

# ── 1 · Iniciar repositorio (solo la primera vez) ────────────────────
if [ -d .git ]; then
    echo "[1/5] Repositorio ya iniciado: se reutiliza."
else
    git init -b main >/dev/null 2>&1 || git init >/dev/null
    git branch -M main >/dev/null 2>&1
    echo "[1/5] Repositorio local iniciado (rama main)."
    read -r -p "      Tu nombre para firmar (ej: Juan Perez): " GITNAME
    read -r -p "      Tu email de GitHub (ej: juan@gmail.com): " GITEMAIL
    git config user.name  "${GITNAME:-Dueno de Ktalogo}"
    git config user.email "${GITEMAIL:-usuario@ejemplo.com}"
fi

# ── 2 · Guardar cambios ──────────────────────────────────────────────
MSG="${1:-Actualizacion Ktalogo-Dgital $(date '+%Y-%m-%d %H:%M')}"
echo "[2/5] Guardando cambios: $MSG"
git add -A
if git commit -m "$MSG" >/dev/null 2>&1; then
    echo "      Cambios guardados en el historial local."
else
    echo "      Sin cambios nuevos que guardar."
fi

# ── 3 · Conectar con GitHub (solo la primera vez) ────────────────────
if ! git remote get-url origin >/dev/null 2>&1; then
    echo ""
    echo "  ──── UNA SOLA VEZ: crea el repositorio en la web ────"
    echo "   1. Entra en:  https://github.com/new"
    echo "      (sin cuenta: primero https://github.com/signup)"
    echo "   2. Repository name: ktalogo-digital"
    echo "   3. Elige Public o Private"
    echo "   4. NO marques 'Add a README' ni licencias"
    echo "   5. Copia la URL, ej: https://github.com/TU-USUARIO/ktalogo-digital.git"
    echo ""
    read -r -p "  Pega aquí la URL de tu repositorio: " URL
    if [ -z "${URL}" ]; then
        echo -e "${rojo}[X] Sin URL no se puede subir. Ejecuta de nuevo.${neutro}"
        exit 1
    fi
    git remote add origin "$URL"
fi
REPOURL="$(git remote get-url origin)"
echo "[3/5] Conectado a: $REPOURL"

# ── 4 · Bajar cambios de otros equipos ───────────────────────────────
echo "[4/5] Buscando cambios nuevos en GitHub..."
if git pull --rebase origin main >/dev/null 2>&1; then
    echo "      Sincronizado con la nube."
else
    echo "      (sin cambios remotos todavía o rama nueva: normal la 1a vez)"
fi

# ── 5 · Subir ────────────────────────────────────────────────────────
echo "[5/5] Subiendo a GitHub..."
if git push -u origin main; then
    echo -e "${verde}════════════════════════════════════════════════════════${neutro}"
    echo -e "${verde} LISTO · Tu proyecto está en GitHub${neutro}"
    echo "  $REPOURL"
    echo ""
    echo "  En OTRA PC:  git clone $REPOURL  →  bash INSTALAR.sh"
    echo -e "${verde}════════════════════════════════════════════════════════${neutro}"
else
    echo -e "${rojo}[X] No se pudo subir. Causas comunes:${neutro}"
    echo "  1. GitHub no acepta contraseñas: usa un Personal Access Token"
    echo "     https://github.com/settings/tokens → Generate new token (classic)"
    echo "     marca 'repo' → cópialo y pégalo cuando pida Password"
    echo "  2. Hay commits remotos que no tienes: ejecuta de nuevo este script"
    echo "  3. URL mal escrita:  git remote set-url origin TU-URL"
    exit 1
fi
