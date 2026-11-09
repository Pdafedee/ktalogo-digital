@echo off
setlocal EnableExtensions
chcp 65001 >nul
title Ktalogo-Dgital · Subir y sincronizar con GitHub
cd /d "%~dp0"

color 0B
echo ============================================================
echo   KTALOGO-DGITAL · SUBIR / SINCRONIZAR CON GITHUB
echo   Un solo clic: sirve la 1a vez y en cada actualizacion
echo ============================================================
echo.
echo  Que hace este asistente:
echo    1. Inicia el repositorio local (solo la 1a vez)
echo    2. Guarda todos los cambios con fecha
echo    3. Conecta con tu repositorio de GitHub (solo la 1a vez)
echo    4. Baja cambios nuevos de otros equipos (si los hay)
echo    5. Sube todo a GitHub
echo.
echo  Guia completa: GITHUB-GUIA.md (esta en esta carpeta)
echo.
pause

REM ── 0 · Comprobar que Git esta instalado ────────────────────────────
echo.
echo [0/5] Comprobando Git...
where git >nul 2>nul
if errorlevel 1 goto sin_git
echo       Git detectado: OK
goto paso1

:sin_git
color 0C
echo.
echo  [X] Git NO esta instalado en este PC.
echo.
echo      1. Abre:  https://git-scm.com/download/win
echo      2. Descarga e instala con TODAS las opciones por defecto
echo         (Next, Next... Install). Marca "Git from the command line".
echo      3. Cierra esta ventana y vuelve a ejecutar SUBIR-A-GITHUB.bat
echo.
pause
exit /b 1

REM ── 1 · Iniciar repositorio (solo la primera vez) ───────────────────
:paso1
echo.
echo [1/5] Preparando repositorio...
if exist ".git" (
    echo       Ya existia: se reutiliza. Nada que hacer.
    goto paso2
)
git init -b main >nul 2>nul || git init >nul
git branch -M main >nul 2>nul
echo       Repositorio local iniciado (rama main).

REM ── Identidad del autor (solo la primera vez) ────────────────────────
git config user.name >nul 2>nul
if errorlevel 1 goto pedir_nombre
goto check_email

:pedir_nombre
set "GITNAME="
set /p GITNAME=       Tu nombre para firmar los cambios (ej: Juan Perez): 
if "%GITNAME%"=="" set "GITNAME=Dueno de Ktalogo"
git config user.name "%GITNAME%"

:check_email
git config user.email >nul 2>nul
if errorlevel 1 goto pedir_email
goto paso2

:pedir_email
set "GITEMAIL="
set /p GITEMAIL=       Tu email de GitHub (ej: juan@gmail.com): 
if "%GITEMAIL%"=="" set "GITEMAIL=cpfedee@gmail.com"
git config user.email "%GITEMAIL%"

REM ── 2 · Guardar cambios ─────────────────────────────────────────────
:paso2
echo.
echo [2/5] Guardando cambios locales...
git add -A
set "MSG=Actualizacion Ktalogo-Dgital %date% %time%"
set /p MSGTXT=       Mensaje del cambio (Enter para usar la fecha): 
if not "%MSGTXT%"=="" set "MSG=%MSGTXT%"
git commit -m "%MSG%" >nul 2>nul
if errorlevel 1 (
    echo       Sin cambios nuevos que guardar (todo estaba igual).
) else (
    echo       Cambios guardados en el historial local.
)

REM ── 3 · Conectar con GitHub (solo la primera vez) ───────────────────
:paso3
echo.
echo [3/5] Conectando con GitHub...
git remote get-url origin >nul 2>nul
if not errorlevel 1 goto remoto_ok

echo.
echo  ---- UNA SOLA VEZ: crea el repositorio en la web ----
echo.
echo   1. Entra en:  https://github.com/new
echo      (si no tienes cuenta, primero: https://github.com/signup)
echo   2. Repository name:  ktalogo-digital
echo   3. Elige Public (visible) o Private (solo tu equipo)
echo   4. NO marques "Add a README" ni ".gitignore" ni licencias
echo   5. Pulsa "Create repository"
echo   6. Copia la URL que te muestra, por ejemplo:
echo        https://github.com/Pdafedee/ktalogo-digital.git
echo.
set "URL="
set /p URL=       Pega aqui la URL de tu repositorio: 
if "%URL%"=="" (
    echo  [X] Sin URL no se puede subir. Ejecuta de nuevo este archivo.
    pause
    exit /b 1
)
git remote add origin "%URL%"

:remoto_ok
for /f "delims=" %%u in ('git remote get-url origin') do set "REPOURL=%%u"
echo       Conectado a: %REPOURL%

REM ── 4 · Bajar cambios de otros equipos ──────────────────────────────
echo.
echo [4/5] Buscando cambios nuevos en GitHub...
git pull --rebase origin main >nul 2>nul
if errorlevel 1 (
    echo       (sin cambios remotos todavia o rama nueva: normal la 1a vez)
) else (
    echo       Sincronizado con lo que haya en la nube.
)

REM ── 5 · Subir a GitHub ──────────────────────────────────────────────
echo.
echo [5/5] Subiendo a GitHub...
git push -u origin main
if errorlevel 1 goto error_push

echo.
color 0A
echo ============================================================
echo   LISTO · Tu proyecto esta en GitHub
echo   %REPOURL%
echo.
echo   Cada vez que quieras guardar una nueva version:
echo     ejecuta de nuevo  SUBIR-A-GITHUB.bat
echo.
echo   Para traerlo a OTRA PC:
echo     1. Instala Git y Python
echo     2. git clone %REPOURL%
echo     3. En la carpeta creada: INSTALAR.bat
echo ============================================================
pause
exit /b 0

:error_push
color 0C
echo.
echo  [X] No se pudo subir. Causas mas comunes:
echo.
echo   1. GitHub ya NO acepta contrasenas normales: usa un TOKEN personal
echo        - Abre: https://github.com/settings/tokens
echo        - "Generate new token (classic)" - marca el casillero "repo"
echo        - Copia el token y pegalo cuando pida Password
echo        (Windows lo guarda: solo lo haras esta vez)
echo.
echo   2. El repositorio remoto tiene commits que no tienes:
echo        ejecuta de nuevo este archivo (el paso 4 los baja primero)
echo.
echo   3. La URL del repositorio esta mal escrita:
echo        git remote set-url origin https://github.com/TU-USUARIO/ktalogo-digital.git
echo.
pause
exit /b 1
