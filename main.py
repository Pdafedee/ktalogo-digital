#!/usr/bin/env python3
"""Ktalogo-Dgital · Punto de entrada.

Uso:
    python main.py              → app de escritorio (PC)
    python main.py --web        → servidor web para TODOS los dispositivos
                                  (PC + celular + tablet; imprime IPs y QR)
    python main.py --web --port 8550
    python main.py --web --host 127.0.0.1   → solo este PC (sin celular)

Requisitos: Python 3.10+ · pip install -r requirements.txt
Sin Docker, sin servidores externos: los datos viven en ./data
"""
from __future__ import annotations
import dataclasses
import sys
import warnings

# v3.5.1 · silencia «RequestsDependencyWarning: urllib3 (x) or chardet (y)
# doesn't match a supported version» que aparece cuando pip instaló una
# versión de requests más vieja que el urllib3/charset_normalizer del equipo.
# Es SOLO un aviso (no afecta la app); la solución de raíz es
# `pip install -U requests urllib3 charset_normalizer` (INSTALAR ya lo pide).
warnings.filterwarnings(
    "ignore", message=r".*doesn'?t match a supported version.*")

import flet as ft  # noqa: E402

import app.config as config
from app.boot import build_ctx
from app.runtime import dir_assets
from app.seed import seed_if_empty
from app.theme import BG, build_theme
from app.ui.shell import Shell

# Núcleo compartido (datos, blockchain, servicios) — uno por proceso;
# cada sesión/pestaña obtiene su propio ctx con user/store independientes.
SHARED = build_ctx()


def new_session_ctx():
    return dataclasses.replace(SHARED, user=None, store=None)


def main(page: ft.Page):
    page.title = f"{config.APP_NAME} v{config.VERSION} · {config.APP_TAGLINE}"
    page.theme_mode = ft.ThemeMode.DARK
    page.theme = build_theme()
    page.bgcolor = BG
    page.padding = 0
    page.window_prevent_close = False

    seed_if_empty(SHARED)
    ctx = new_session_ctx()
    Shell(page, ctx).render()


def run():
    args = sys.argv[1:]
    web = "--web" in args
    # Sello de build: si no lees esta línea en consola, NO estás ejecutando
    # los archivos actualizados (queda alguna copia antigua en el disco).
    print(f"⚡ {config.APP_NAME} v{config.VERSION} · build con configuración "
          "blindada (cargador .env tolerante)")
    port = 8550
    if "--port" in args:
        i = args.index("--port")
        try:
            port = int(args[i + 1])
        except (IndexError, ValueError):
            port = 8550          # --port sin valor o inválido → puerto por defecto
        port = max(1024, min(65535, port))
    # Modo web: escuchar en TODAS las interfaces para que el celular/tablet
    # (u otro equipo) pueda entrar. --host permite limitarlo (p.ej. 127.0.0.1).
    host = "0.0.0.0" if web else None
    if "--host" in args:
        i = args.index("--host")
        try:
            host = args[i + 1].strip() or None
        except IndexError:
            host = "0.0.0.0" if web else None
    if web:
        from app.netinfo import mostrar_acceso_web

        mostrar_acceso_web(port, abrir_qr=(host == "0.0.0.0"))
    # assets_dir (v3.0): en ejecutable viven empaquetados en _MEIPASS/assets;
    # en fuente, la carpeta assets/ del proyecto (igual que siempre).
    print(f"[i] Datos en: {config.BASE_DIR}")
    ft.run(main, view=(ft.AppView.WEB_BROWSER if web else ft.AppView.FLET_APP),
           host=host, port=port, assets_dir=dir_assets())


if __name__ == "__main__":
    run()
