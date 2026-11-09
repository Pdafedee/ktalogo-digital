@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title Ktalogo-Dgital v3.0 · Crear ejecutable de Windows (PyInstaller)
cd /d "%~dp0"

set "VER=3.0.0"
set "APP=KtalogoDgital"

color 0B
echo ============================================================
echo   KTALOGO-DGITAL v%VER% · CREAR EJECUTABLE DE WINDOWS
echo   Un solo clic genera los 2 formatos:
echo     1) %APP%.exe  (un solo archivo, para llevar en USB)
echo     2) Carpeta portable (arranque mas rapido, ideal en red)
echo ============================================================
echo.
echo  Requisitos: este .bat hace TODO solo (usa Python ya instalado).
echo  Tiempo estimado: 5-15 minutos la primera vez (descarga el
echo  motor de Flet y compila); 3-8 minutos en las siguientes.
echo.
echo  Guia completa: GUIA-EJECUTABLE.pdf
echo.
pause

REM ── 0 · Localizar Python (el mismo que instalo INSTALAR.bat) ────────────
set "PY="
if exist ".venv\Scripts\python.exe" set "PY=.venv\Scripts\python.exe"
if not defined PY (
    py -3 -c "import sys;sys.exit(0 if sys.version_info>=(3,10) else 1)" >nul 2>nul && set "PY=py -3"
)
if not defined PY (
    python -c "import sys;sys.exit(0 if sys.version_info>=(3,10) else 1)" >nul 2>nul && set "PY=python"
)
if not defined PY goto sin_python
echo [0/6] Python detectado: !PY!
goto crear_venv_ok

:sin_python
color 0C
echo.
echo  [X] Python 3.10+ no encontrado.
echo      Ejecuta antes INSTALAR.bat (crea Python + .venv automaticamente)
echo      o instala Python desde https://www.python.org/downloads/
echo.
pause
exit /b 1

:crear_venv_ok
REM ── 1 · Entorno virtual (reutiliza el de INSTALAR.bat si existe) ────────
if exist ".venv\Scripts\python.exe" (
    echo [1/6] Reutilizando el entorno virtual .venv de tu instalacion.
    goto instalar_deps
)
echo [1/6] Creando entorno virtual .venv...
!PY! -m venv .venv || (echo  [X] No se pudo crear .venv & pause & exit /b 1)
set "PY=.venv\Scripts\python.exe"

:instalar_deps
REM ── 2 · Dependencias + PyInstaller ──────────────────────────────────────
echo [2/6] Instalando dependencias + PyInstaller (2-4 min)...
!PY! -m pip install --upgrade pip -q
!PY! -m pip install -r requirements.txt "flet[cli]==1.0.5" pyinstaller -q
if errorlevel 1 goto fallo_pip
!PY! -c "import PyInstaller, flet_cli" 2>nul || goto fallo_pip
echo       Listo.
set "FLET=.venv\Scripts\flet.exe"
if exist "!FLET!" goto limpiar
where flet >nul 2>nul && set "FLET=flet"
if "!FLET!"=="flet" goto limpiar
goto fallo_pip

:limpiar
REM ── 3 · Compilar formato 1: UN SOLO ARCHIVO .EXE ────────────────────────
echo.
echo [3/6] Compilando %APP%.exe (1 solo archivo)... 3-6 minutos, no cierres.
if exist "build-exe" rmdir /s /q "build-exe"
"!FLET!" pack main.py -y -n %APP% -i ktalogo.ico ^
  --product-name "Ktalogo-Dgital" --product-version %VER% --file-version %VER% ^
  --file-description "Tu vitrina digital que vende por ti" ^
  --company-name "Ktalogo-Dgital" --copyright "(c) Ktalogo-Dgital" ^
  --add-data "assets;assets" --distpath build-exe\onefile ^
  -- --collect-all flet_web --collect-all flet_charts
if not exist "build-exe\onefile\%APP%.exe" goto fallo_build
for %%F in ("build-exe\onefile\%APP%.exe") do set "SZ1=%%~zF"
echo       OK: build-exe\onefile\%APP%.exe (!SZ1! bytes)

REM ── 4 · Compilar formato 2: CARPETA PORTABLE ────────────────────────────
echo.
echo [4/6] Compilando carpeta portable... 3-6 minutos, no cierres.
"!FLET!" pack main.py -y -D -n %APP% -i ktalogo.ico ^
  --product-name "Ktalogo-Dgital" --product-version %VER% --file-version %VER% ^
  --file-description "Tu vitrina digital que vende por ti" ^
  --company-name "Ktalogo-Dgital" --copyright "(c) Ktalogo-Dgital" ^
  --add-data "assets;assets" --distpath build-exe\onedir ^
  -- --collect-all flet_web --collect-all flet_charts
if not exist "build-exe\onedir\%APP%\%APP%.exe" goto fallo_build
echo       OK: build-exe\onedir\%APP%\

REM ── 5 · Ensamblar la carpeta release lista para repartir ────────────────
echo.
echo [5/6] Ensambrando la carpeta release\ ...
if exist "release" rmdir /s /q "release"
mkdir "release" 2>nul
copy /y "build-exe\onefile\%APP%.exe" "release\%APP%-PORTABLE.exe" >nul
xcopy /e /i /q /y "build-exe\onedir\%APP%" "release\%APP%-Carpeta" >nul
copy /y ".env.example" "release\%APP%-Carpeta\.env.example" >nul 2>nul
copy /y ".env.example" "release\.env.example" >nul 2>nul

REM ── 6 · Resumen final ───────────────────────────────────────────────────
echo.
color 0A
echo [6/6] EJECUTABLES LISTOS en la carpeta release\ de este proyecto:
echo.
echo   release\%APP%-PORTABLE.exe        (doble clic y abre; ideal USB)
echo   release\%APP%-Carpeta\%APP%.exe   (arranque rapido; ideal red del local)
echo.
echo  Primer arranque: la app crea data\ junto al exe (base de datos
echo  nueva). Para llevar TUS datos: copia tambien tu carpeta data\.
echo.
echo  Si Windows muestra "Protegio tu PC" (SmartScreen): clic en
echo  "Mas informacion" y luego "Ejecutar de todas formas" - es normal
echo  en ejecutables sin firma digital.
echo.
explorer "release"
pause
exit /b 0

:fallo_pip
color 0C
echo.
echo  [X] Fallo al instalar dependencias. Causas comunes:
echo      - Sin internet o proxy corporativo: prueba otra red o VPN off
echo      - Ejecuta de nuevo este archivo (a veces es un fallo puntual)
echo.
pause
exit /b 1

:fallo_build
color 0C
echo.
echo  [X] La compilacion fallo. Revisa el mensaje rojo de arriba.
echo      Lo mas habitual:
echo      - Antivirus bloqueando PyInstaller: agrega esta carpeta a exclusiones
echo      - Falta espacio en disco (se necesitan ~3 GB libres)
echo      - Ejecuta de nuevo: la segunda pasada suele resolver
echo.
pause
exit /b 1
