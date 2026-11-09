#!/usr/bin/env bash
# Ktalogo-Dgital · Lanzador (escritorio por defecto, --web para celular)
#   ./INICIAR.sh          → app de escritorio
#   ./INICIAR.sh --web    → servidor web (abre desde celular/otro equipo)
cd "$(dirname "$0")"
PY=.venv/bin/python; [ -x "$PY" ] || PY=python3

find . -type d -name __pycache__ -prune -exec rm -rf {} + 2>/dev/null

"$PY" scripts/doctor.py || true

if [ "${1:-}" = "--web" ]; then
    exec "$PY" main.py --web "${@:2}"
else
    exec "$PY" main.py "$@"
fi
