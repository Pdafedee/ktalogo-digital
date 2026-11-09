@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Ktalogo-Dgital v2.1.0 · Instalador automatico (PC Windows)
cd /d "%~dp0"

color 0B
echo ============================================================
echo   Ktalogo-Dgital v2.1.0 · INSTALADOR AUTOMATICO
echo   PC Windows · un solo clic, sin conocimientos tecnicos
echo ============================================================
echo.
echo  Este asistente hace TODO por ti:
echo    1. Corrige el proxy del sistema (evita el error MalformedURLException)
echo    2. Detecta e instala Python si falta
echo    3. Crea el entorno virtual (.venv) aislado
echo    4. Instala todas las dependencias
echo    5. Verifica el sistema con el Doctor
echo    6. Crea accesos directos en el Escritorio
echo.
echo  Solo debes ejecutarlo UNA VEZ (tambien sirve para actualizar).
echo.
pause

REM ── 0 · Proxy sin protocolo (causa nº1 de fallos con Java/pip) ──────────
echo.
call :fix_proxy

REM ── 1 · Detectar o instalar Python ───────────────────────────────────────
set "PYCMD="
python -c "import sys; sys.exit(0 if sys.version_info>=(3,10) else 1)" >nul 2>nul && set "PYCMD=python"
if not defined PYCMD (
    py -3 -c "import sys; sys.exit(0 if sys.version_info>=(3,10) else 1)" >nul 2>nul && set "PYCMD=py -3"
)
if defined PYCMD goto have_python

echo.
echo [1/6] Python 3.10+ no encontrado. Instalando con winget...
winget install -e --id Python.Python.3.12 --accept-source-agreements --accept-package-agreements
REM Refrescar rutas conocidas de Python en esta sesion (PATH no se recarga solo)
set "PATH=%LOCALAPPDATA%\Programs\Python\Python312;%LOCALAPPDATA%\Programs\Python\Python312\Scripts;%ProgramFiles%\Python312;%PATH%"
set "PYCMD="
python -c "import sys; sys.exit(0 if sys.version_info>=(3,10) else 1)" >nul 2>nul && set "PYCMD=python"
if defined PYCMD goto have_python
echo.
echo [!] No se pudo dejar Python listo en esta sesion.
echo     SOLUCION: instala Python a mano (2 minutos):
echo       https://www.python.org/downloads/
echo     MUY IMPORTANTE: marca la casilla "Add python.exe to PATH".
echo     Luego CIERRA esta ventana, abre una nueva y reejecuta INSTALAR.bat
echo.
pause
exit /b 1

:have_python
echo.
echo [1/6] Python OK: %PYCMD%

REM ── 2 · Entorno virtual ──────────────────────────────────────────────────
set "VENV=1"
if exist ".venv\Scripts\python.exe" (
    echo [2/6] Entorno virtual .venv ya existe (se reutiliza^)
    goto have_venv
)
echo [2/6] Creando entorno virtual .venv...
%PYCMD% -m venv .venv
if errorlevel 1 (
    echo [!] No se pudo crear .venv - faltan permisos? Se usara Python del sistema.
    set "VENV="
) else (
    echo     Entorno .venv creado correctamente.
)
:have_venv
set "PIP=.venv\Scripts\python.exe -m pip"
if not defined VENV set "PIP=%PYCMD% -m pip"

REM ── 3 · Dependencias (con reintento sin proxy) ───────────────────────────
echo.
echo [3/6] Instalando dependencias (flet, charts, PDF, QR...^)
echo       puede tardar 2-5 minutos segun tu conexion...
%PIP% install --upgrade pip >nul 2>nul
%PIP% install -r requirements.txt
if errorlevel 1 (
    echo.
    echo [!] Reintento SIN proxy (por si el proxy bloquea PyPI^)...
    set "HTTP_PROXY="
    set "HTTPS_PROXY="
    %PIP% install -r requirements.txt
    if errorlevel 1 (
        echo.
        echo [!] La instalacion de dependencias FALLO.
        echo     Causas tipicas: sin internet, proxy/VPN bloqueando PyPI,
        echo     o antivirus bloqueando pip. Revisa y vuelve a ejecutar.
        echo.
        pause
        exit /b 1
    )
)
echo     Dependencias instaladas.

REM ── 4 · Doctor ───────────────────────────────────────────────────────────
echo.
echo [4/6] Verificando el sistema (Doctor de entorno)...
echo ------------------------------------------------------------
set "DRUN=.venv\Scripts\python.exe"
if not defined VENV set "DRUN=%PYCMD%"
%DRUN% scripts\doctor.py
set "DOCTOR_ERR=%errorlevel%"
echo ------------------------------------------------------------
if not "%DOCTOR_ERR%"=="0" (
    echo [!] El Doctor detecto detalles (revisalos arriba^).
    echo     Si es solo el aviso del .env, puedes continuar con tranquilidad.
)

REM ── 5 · Accesos directos ─────────────────────────────────────────────────
echo.
echo [5/6] Creando accesos directos en el Escritorio...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$d=[Environment]::GetFolderPath('Desktop'); $ws=New-Object -ComObject WScript.Shell; $s=$ws.CreateShortcut(($d)+'\Ktalogo-Dgital.lnk'); $s.TargetPath=('%CD%')+'\INICIAR.bat'; $s.WorkingDirectory=('%CD%'); $s.IconLocation='%SystemRoot%\System32\SHELL32.dll,21'; $s.Save(); $s2=$ws.CreateShortcut(($d)+'\Ktalogo-Dgital WEB (celular).lnk'); $s2.TargetPath=('%CD%')+'\INICIAR-WEB.bat'; $s2.WorkingDirectory=('%CD%'); $s2.IconLocation='%SystemRoot%\System32\SHELL32.dll,14'; $s2.Save()" >nul 2>nul
if errorlevel 1 (
    echo     (accesos directos no creados - podras iniciar con INICIAR.bat igualmente^)
) else (
    echo     "Ktalogo-Dgital" y "Ktalogo-Dgital WEB (celular^)" creados en el Escritorio.
)

REM ── 6 · Informe final ────────────────────────────────────────────────────
echo.
echo [6/6] INSTALACION COMPLETADA
echo ============================================================
echo   COMO USAR Ktalogo-Dgital desde hoy:
echo.
echo   [PC - escritorio]     doble clic en INICIAR.bat
echo                         (o el acceso directo del Escritorio)
echo.
echo   [CELULAR / TABLET /   doble clic en INICIAR-WEB.bat
echo    OTRO DISPOSITIVO]    te mostrara una direccion como
echo                         http://192.168.1.x:8550 - abrela en
echo                         el navegador del otro dispositivo
echo                         (misma red Wi-Fi^)
echo.
echo   [ANDROID - app]       APK compilado en la nube, sin SDK:
echo                         ver docs\GUIA_APK.md (Ruta A)
echo ============================================================
echo.
choice /c SN /n /m "Abrir la aplicacion ahora? [S/N]: "
if errorlevel 2 goto fin
start "" "%CD%\INICIAR.bat"

:fin
echo.
echo Gracias por usar Ktalogo-Dgital.
endlocal
exit /b 0

REM ── Función: corrige proxy sin http:// (solo en esta sesion) ─────────────
:fix_proxy
call :fix_one HTTP_PROXY
call :fix_one HTTPS_PROXY
goto :eof

:fix_one
if not defined %1 (
    echo   [ok] %1 no esta definido
    goto :eof
)
call set "v=%%%1%%"
echo %v%| findstr /c:"://" >nul
if not errorlevel 1 (
    echo   [ok] %1 ya tiene protocolo: %v%
    goto :eof
)
echo   [i] %1 sin protocolo: "%v%"
set "%1=http://%v%"
echo       corregido a: http://%v%  (solo en esta sesion, no toca tu Windows)
goto :eof
